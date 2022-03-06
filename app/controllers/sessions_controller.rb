# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
    info = Discord.connect(params[:code])
    if info.present?
      user = update_user(info)
      if user.present?
        connect(user.id)
        redirect_to marks_url
      else
        redirect_to root_url
      end
    else
      disconnect
      render 'new', locals: { url: Discord.authorize_url }
    end
  end

  private

  def update_user(info)
    user = User.find_or_create_by!(discord_id: info[:me][:id]) do |v|
      v.name = info[:me][:username]
      v.display_name = info[:me][:username]
      v.discriminator = info[:me][:discriminator]
      v.avatar = info[:me][:avatar]
    end
    user.update!(admin: info[:guild][:owner], in_use: true, expires_at: Discord.expires_at)
    user
  end
end
