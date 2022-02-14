# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @channel_id = Faker::Number.number(digits: 18)
    @content0_id = Faker::Number.number(digits: 18)
    @content1_id = Faker::Number.number(digits: 18)
  end

  # user、channel_id、content_id、content、wrote_atがあれば有効な状態であること
  it 'is valid with a user, channel_id, content_id, content, and wrote_at' do
    @user.messages.create(
      channel_id: @channel_id,
      content_id: @content0_id,
      content: 'content_0',
      wrote_at: Time.current
    )
    message = @user.messages.build(
      channel_id: @channel_id,
      content_id: @content1_id,
      content: 'content_1',
      wrote_at: Time.current
    )
    expect(message).to be_valid
  end

  # contentがなければ無効な状態であること
  it 'is invalid without a content' do
    message = @user.messages.build(
      channel_id: @channel_id,
      content_id: @content0_id,
      content: '',
      wrote_at: Time.current
    )
    message.valid?
    expect(message.errors[:content]).to include("can't be blank")
  end

  # userがなければ無効な状態であること
  it 'is invalid without a user' do
    message = Message.new(
      channel_id: @channel_id,
      content_id: @content0_id,
      content: 'content',
      wrote_at: Time.current,
      user: nil
    )
    message.valid?
    expect(message.errors[:user]).to include('must exist')
  end

  # チャンネル単位では重複したコンテンツを許可しないこと
  it 'does not allow duplicate content_id per channel_id' do
    @user.messages.create(
      channel_id: @channel_id,
      content_id: @content0_id,
      content: 'content_0',
      wrote_at: Time.current
    )
    message = @user.messages.build(
      channel_id: @channel_id,
      content_id: @content0_id,
      content: 'content_1',
      wrote_at: Time.current
    )
    message.valid?
    expect(message.errors[:channel_id]).to include('has already been taken')
  end
end
