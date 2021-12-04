# frozen_string_literal: true

require 'test_helper'

class Api::UsersTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user1)

    @api_token = ENV['STAMPON_API_TOKEN']

    @session = { user_id: @user.id }
    @user.update!(expires_at: Time.current + 3.hours)
  end

  test 'DELETE /api/users/:id with session' do
    ApplicationController.stub_any_instance :session, @session do
      user_id = @user.id

      assert_difference 'User.count', -1 do
        delete api_user_path(user_id), params: nil, headers: nil
      end
      assert_response :success

      assert_not User.find_by(id: user_id)
    end
  end

  test 'DELETE /api/users/:id with token' do
    assert_difference 'User.count', 0 do
      delete api_user_path(@user.id), params: nil, headers: { 'Authorization' => "Bearer #{@api_token}" }
    end
    assert_response :unauthorized
  end
end
