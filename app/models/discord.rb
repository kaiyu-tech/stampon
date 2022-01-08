# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'json'

module Discord
  def authorize_url
    discord_uri = 'https://discord.com/oauth2/authorize'
    encoded_redirect_uri = URI.encode_www_form_component(redirect_uri)
    "#{discord_uri}?client_id=#{client_id}&redirect_uri=#{encoded_redirect_uri}&response_type=code&scope=#{scope}"
  end

  def discord(code)
    return if code.blank?

    token = token(code)
    guild = guild(token[:token_type], token[:access_token])
    return if guild.blank?

    me = me(token[:token_type], token[:access_token])
    { guild: guild, me: me }
  end

  def member(user_id)
    res = https_get("https://discord.com/api/guilds/#{guild_id}/members/#{user_id}", 'Bot', bot_access_token)

    return if res.code == '404'

    { id: parse(res)['user']['id'], username: parse(res)['user']['username'], display_name: parse(res)['nick'],
      discriminator: parse(res)['user']['discriminator'], avatar: parse(res)['user']['avatar'] }
  end

  def message(channel_id, message_id)
    res = https_get("https://discord.com/api/channels/#{channel_id}/messages/#{message_id}", 'Bot', bot_access_token)

    return if res.code == '404'

    content = parse(res)['content'].gsub(/<(:\w+:)\d{18}>?/) { Regexp.last_match(1) }
                                   .gsub(/<@?(\d{18})>?/) do
      "@#{parse(res)['mentions'].find do |user|
        user['id'] == Regexp.last_match(1)
      end ['username']}"
    end

    { channel_id: parse(res)['channel_id'], id: parse(res)['id'], content: content, wrote_at: parse(res)['timestamp'] }
  end

  private

  def client_id
    ENV['DISCORD_CLIENT_ID']
  end

  def client_secret
    ENV['DISCORD_CLIENT_SECRET']
  end

  def grant_type
    'authorization_code'
  end

  def redirect_uri
    ENV['DISCORD_REDIRECT_URI']
  end

  def scope
    ENV['DISCORD_SCOPE']
  end

  def guild_id
    ENV['DISCORD_GUILD_ID']
  end

  def bot_access_token
    ENV['DISCORD_BOT_ACCESS_TOKEN']
  end

  def expires_at
    Time.current + ENV['STAMPON_EXPIRES_IN']
  end

  def parse(res)
    JSON.parse(res.body)
  end

  def token(code)
    uri = URI.parse('https://discord.com/api/oauth2/token')
    res = Net::HTTP.post_form(uri,
                              { 'client_id' => client_id, 'client_secret' => client_secret,
                                'grant_type' => grant_type, 'code' => code, 'redirect_uri' => redirect_uri })

    { token_type: parse(res)['token_type'], access_token: parse(res)['access_token'],
      refresh_token: parse(res)['refresh_token'] }
  end

  def https_get(uri, token_type, access_token)
    uri = URI.parse(uri)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    req = Net::HTTP::Get.new(uri.request_uri, { Authorization: "#{token_type} #{access_token}" })
    https.request(req)
  end

  def me(token_type, access_token)
    res = https_get('https://discord.com/api/users/@me', token_type, access_token)
    { id: parse(res)['id'], username: parse(res)['username'], discriminator: parse(res)['discriminator'],
      avatar: parse(res)['avatar'] }
  end

  def guild(token_type, access_token)
    res = https_get('https://discord.com/api/users/@me/guilds', token_type, access_token)
    parse(res).each do |guild|
      return { id: guild['id'], name: guild['name'], owner: guild['owner'] } if guild['id'].eql?(guild_id)
    end
    nil
  end
end
