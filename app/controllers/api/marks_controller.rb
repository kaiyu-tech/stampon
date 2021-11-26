# frozen_string_literal: true

class Api::MarksController < ApplicationController
  before_action :authentication_required
  protect_from_forgery except: :create

  def index
    @user = User.find(current_user)
    @marks = Mark.where(user_id: current_user).order('id DESC')
  end

  def create
    user = User.find_by(discord_id: mark_params[:user_id])
    if user.present?
      author = author(mark_params)
      message = message(mark_params, author)
      Mark.find_or_create_by!(user: user, message: message)

      render json: { message: 'OK' }, status: :ok
    else
      render json: { message: 'Not user' }, status: :ok
    end
  end

  def edit
    @user = User.find(current_user)
    @mark = Mark.where(user_id: current_user).find(params[:id])
  end

  def update
    mark = Mark.find(params[:id])
    mark.title = params[:title]
    mark.note = params[:note]
    if mark.save
      render json: { message: 'OK' }, status: :ok
    else
      render json: mark.errors, status: :unprocessable_entity
    end
  end

  def destroy
    message_id = Mark.find(params[:id]).message_id
    Mark.destroy(params[:id])
    user_id = Message.find(message_id).user_id
    Message.destroy(message_id) if Mark.find_by(message_id: message_id).nil?
    User.destroy(user_id) if Message.find_by(user_id: user_id).nil? && !User.find(user_id).in_use
  end

  private

  def mark_params
    params.require(:discord).permit(:channel_id, :content_id, :user_id, :user_name, :user_discriminator,
                                    :user_display_name, :user_avatar,
                                    :author_id, :author_name, :author_discriminator, :author_display_name,
                                    :author_avatar, :content, :wrote_at)
  end

  def author(mark_params)
    author = User.find_or_create_by!(discord_id: mark_params[:author_id]) do |v|
      v.name = mark_params[:author_name]
      v.discriminator = mark_params[:author_discriminator]
      v.display_name = mark_params[:author_name]
      v.avatar = mark_params[:author_avatar]
      v.admin = false
      v.in_use = false
    end
    author.update!(display_name: mark_params[:author_display_name]) if mark_params[:author_display_name]
    author
  end

  def message(mark_params, author)
    Message.find_or_create_by!(channel_id: mark_params[:channel_id], content_id: mark_params[:content_id]) do |v|
      v.channel_id = mark_params[:channel_id]
      v.content_id = mark_params[:content_id]
      v.content = mark_params[:content]
      v.wrote_at = Time.zone.at(mark_params[:wrote_at].to_i / 1000.0)
      v.user = author
    end
  end
end
