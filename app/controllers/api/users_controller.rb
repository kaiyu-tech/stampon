# frozen_string_literal: true

class API::UsersController < ApplicationController
  before_action :authentication_required
  protect_from_forgery

  def destroy
    User.destroy(params[:id])
  end
end
