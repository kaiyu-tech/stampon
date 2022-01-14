# frozen_string_literal: true

class API::UsersController < ApplicationController
  before_action :authentication_required
  protect_from_forgery

  def destroy
    user = User.find(params[:id])
    user.marks.destroy_all
    user.update!(in_use: false)
    user.messages.each do |message|
      message.destroy if message.marks.empty?
    end
    User.all.each do |v|
      v.destroy if !v.in_use && v.messages.empty?
    end
  end
end
