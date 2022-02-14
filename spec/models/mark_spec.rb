# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mark, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @other_user = FactoryBot.create(:other_user)
    @message0 = FactoryBot.create(:message0)
    @message1 = FactoryBot.create(:message1)
  end

  # user、message、readがあれば有効な状態であること
  it 'is valid with a user, message, and read' do
    mark = @user.marks.build(
      message: @message0,
      title: '',
      note: '',
      read: false
    )
    expect(mark).to be_valid
  end

  # messageがなければ無効な状態であること
  it 'is invalid without a message' do
    mark = Mark.new(
      user: @user,
      message: nil,
      title: '',
      note: '',
      read: false
    )
    mark.valid?
    expect(mark.errors[:message]).to include('must exist')
  end

  # userがなければ無効な状態であること
  it 'is invalid without a user' do
    mark = Mark.new(
      user: nil,
      message: @message0,
      title: '',
      note: '',
      read: false
    )
    mark.valid?
    expect(mark.errors[:user]).to include('must exist')
  end

  # ユーザーが異なれば重複したメッセージを許可すること
  it 'allow duplicate messages for different users' do
    @user.marks.create(
      message: @message0,
      title: '',
      note: '',
      read: false
    )
    mark = @other_user.marks.build(
      message: @message0,
      title: '',
      note: '',
      read: false
    )
    expect(mark).to be_valid
  end

  # ユーザーが同じならば重複したメッセージを許可しないこと
  it "don't allow duplicate messages to the same user" do
    @user.marks.create(
      message: @message0,
      title: '',
      note: '',
      read: false
    )
    mark = @user.marks.build(
      message: @message0,
      title: '',
      note: '',
      read: false
    )
    mark.valid?
    expect(mark.errors[:user_id]).to include('has already been taken')
  end

  # ユーザーに一致するブックマークを返すこと
  it 'returning matching bookmarks to the user' do
    mark0 = @user.marks.create(
      message: @message0,
      title: '',
      note: '',
      read: false
    )
    mark1 = @other_user.marks.create(
      message: @message0,
      title: '',
      note: '',
      read: false
    )
    mark2 = @user.marks.create(
      message: @message1,
      title: '',
      note: '',
      read: false
    )
    expect(Mark.where(user: @user)).to include(mark0, mark2)
    expect(Mark.where(user: @user)).to_not include(mark1)
    expect(Mark.where(user: @other_user)).to include(mark1)
    expect(Mark.where(user: @other_user)).to_not include(mark0, mark2)
  end
end
