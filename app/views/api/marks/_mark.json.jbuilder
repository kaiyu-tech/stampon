# frozen_string_literal: true

json.id mark.id.to_s

json.discord do
  json.guild_id ENV['DISCORD_GUILD_ID']
  json.channel_id mark.message.channel_id.to_s
  json.content_id mark.message.content_id.to_s
  json.content mark.message.content
  json.wrote_at mark.message.wrote_at.strftime('%y/%m/%d %H:%M')
end

json.author do
  json.name mark.message.user.name
  json.display_name mark.message.user.display_name
  json.id mark.message.user.discord_id.to_s
  json.avatar mark.message.user.avatar
end

json.title mark.title
json.note mark.note
