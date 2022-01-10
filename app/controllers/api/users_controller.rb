# frozen_string_literal: true

class API::UsersController < ApplicationController
  before_action :authentication_required
  protect_from_forgery

  def destroy
    user = User.find(params[:id])
    user.marks.destroy_all
    # user.messages.destroy_all
    user.update!(in_use: false)
  end
end
