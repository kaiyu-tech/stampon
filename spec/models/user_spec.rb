# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @discord_id = Faker::Number.number(digits: 18)
    @discriminator = Faker::Number.number(digits: 4)
    @avatar = Faker::Number.hexadecimal(digits: 32)
  end

  # discord_id、name、discriminator、display_name、avatar、admin、in_use、expires_atがあれば有効な状態であること
  it 'is valid with a discord_id, name, discriminator, display_name, avatar, admin, in_use, and expires_at' do
    user = User.new(
      discord_id: @discord_id,
      name: 'user',
      discriminator: @discriminator,
      display_name: 'user_nickname',
      avatar: @avatar,
      admin: true,
      in_use: true,
      expires_at: nil
    )
    expect(user).to be_valid
  end

  # 名前がなければ無効な状態であること
  it 'is invalid without a name' do
    user = User.new(
      discord_id: @discord_id,
      name: '',
      discriminator: @discriminator,
      display_name: 'user_nickname',
      avatar: @avatar,
      admin: true,
      in_use: true,
      expires_at: nil
    )
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
  end

  # 表示名がなければ無効な状態であること
  it 'is invalid without a display name' do
    user = User.new(
      discord_id: @discord_id,
      name: 'user',
      discriminator: @discriminator,
      display_name: '',
      avatar: @avatar,
      admin: true,
      in_use: true,
      expires_at: nil
    )
    user.valid?
    expect(user.errors[:display_name]).to include("can't be blank")
  end

  # 重複したdiscord_idなら無効な状態であること
  it 'is invalid with a duplicate discord id' do
    User.create(
      discord_id: @discord_id,
      name: 'user',
      discriminator: @discriminator,
      display_name: 'user_nickname',
      avatar: @avatar,
      admin: true,
      in_use: true,
      expires_at: nil
    )
    user = User.new(
      discord_id: @discord_id,
      name: 'user',
      discriminator: @discriminator,
      display_name: 'user_nickname',
      avatar: @avatar,
      admin: true,
      in_use: true,
      expires_at: nil
    )
    user.valid?
    expect(user.errors[:discord_id]).to include('has already been taken')
  end
end
