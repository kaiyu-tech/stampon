# frozen_string_literal: true

class SessionsController < ApplicationController
  include Discord

  def new
    discord = discord(params[:code])
    if discord.present?
      user = user(discord)
      if user.present?
        connect(user.id)
        redirect_to main_url
      else
        redirect_to root_url
      end
    else
      disconnect
      render 'new', locals: { url: authorize_url }
    end
  end

  private

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
end
