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
end
