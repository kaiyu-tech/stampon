# frozen_string_literal: true

class SyncData
  include Discord

  def initialize
  end

  def exec
    User.all.each do |v|
      member = member(v[:discord_id])
      next if member.nil?
      update_user(member)
    end

    Message.all.each do |v|
      message = message(v[:channel_id], v[:content_id])
      next if message.nil?
      update_message(message)
    end
  end

  private

  def update_user(params)
    user = User.find_by(discord_id: params[:id])
    user.update!(name: params[:username],
                 display_name: params[:display_name] || params[:username],
                 discriminator: params[:discriminator],
                 avatar: params[:avatar])
  end

  def update_message(params)
    message = Message.find_by(content_id: params[:id])
    message.update!(content: params[:content], wrote_at: params[:wrote_at])
  end
end
