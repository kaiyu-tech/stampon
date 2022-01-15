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

    remove_unused_users
  end

  private

  def remove_unused_users
    User.all.each do |user|
      user.destroy if !user.in_use && user.messages.empty?
    end
  end
end
