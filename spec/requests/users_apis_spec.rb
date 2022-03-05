# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  before do
    @user = FactoryBot.create(:user)
  end

  describe 'ユーザーを削除する' do
    context 'ユーザーのメッセージがブックマークされていない時' do
      it 'ユーザーを削除できること' do
        sign_in_as(@user)

        user_id = @user.id

        delete api_user_path(user_id), params: nil, headers: nil
        expect(response).to have_http_status(:success)

        expect(User.find_by(id: user_id)).to be_nil
      end
    end

    context 'ユーザーのメッセージがブックマークされている時' do
      it 'ユーザーが削除されず、使用中フラグがfalseに設定されること' do
        other_user = FactoryBot.create(:other_user)
        message = FactoryBot.create(:message0, user: @user)
        FactoryBot.create(:mark0, user: other_user, message: message)

        sign_in_as(@user)

        delete api_user_path(@user), params: nil, headers: nil
        expect(response).to have_http_status(:success)

        @user.reload
        expect(@user.in_use).to be false
      end
    end

    context 'ログインしていない時' do
      it 'ユーザーが削除されないこと' do
        user_id = @user.id

        delete api_user_path(@user), params: nil, headers: nil
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context '有効なトークンを渡した時' do
      it 'ユーザーが削除されないこと' do
        user_id = @user.id

        delete api_user_path(@user), params: nil, headers: { 'Authorization' => "Bearer #{ENV['STAMPON_API_TOKEN']}" }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
