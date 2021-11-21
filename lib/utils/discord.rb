# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'json'

module Discord
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

  def parse(res)
    JSON.parse(res.body)
  end

  def authorize_url
    discord_uri = 'https://discord.com/oauth2/authorize'
    encoded_redirect_uri = URI.encode_www_form_component(redirect_uri)
    "#{discord_uri}?client_id=#{client_id}&redirect_uri=#{encoded_redirect_uri}&response_type=code&scope=#{scope}"
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

  def discord(code)
    return if code.blank?

    token = token(code)
    guild = guild(token[:token_type], token[:access_token])
    return if guild.blank?

    me = me(token[:token_type], token[:access_token])
    { guild: guild, me: me }
  end

  def user(discord)
    user = User.find_or_create_by!(discord_id: discord[:me][:id]) do |v|
      v.name = discord[:me][:username]
      v.display_name = discord[:me][:username]
      v.discriminator = discord[:me][:discriminator]
      v.avatar = discord[:me][:avatar]
    end
    user.update!(admin: discord[:guild][:owner], in_use: true, expires_at: expires_at)
    user
  end

  def expires_at
    Time.current + ENV['STAMPON_EXPIRES_IN']
  end
end
