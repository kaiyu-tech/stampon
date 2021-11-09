# frozen_string_literal: true

json.id mark.id.to_s

json.discord do
  json.guild_id ENV['DISCORD_GUILD_ID']
  json.channel_id mark.message.channel_id.to_s
  json.content_id mark.message.content_id.to_s
  json.content mark.message.content
end

json.author do
  json.name mark.message.user.name
  json.id mark.message.user.discord_id.to_s
  json.avatar mark.message.user.avatar
end

json.title mark.title
json.note mark.note
