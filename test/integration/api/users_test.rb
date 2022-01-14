# frozen_string_literal: true

require 'test_helper'

class API::UsersTest < ActionDispatch::IntegrationTest
  setup do
    @user1 = users(:user1)
    @user2 = users(:user2)

    @api_token = ENV['STAMPON_API_TOKEN']

    @session1 = { user_id: @user1.id }
    @user1.update!(expires_at: Time.current + 3.hours)

    @session2 = { user_id: @user2.id }
    @user2.update!(expires_at: Time.current + 3.hours)
  end

  test 'DELETE /api/users/:id with session' do
    ApplicationController.stub_any_instance :session, @session1 do
      user_id = @user1.id

      assert_difference 'User.count', 0 do
        delete api_user_path(user_id), params: nil, headers: nil
      end
      assert_response :success

      user = User.find(user_id)
      assert_not user.messages.empty?
      assert_not user.in_use
    end
    ApplicationController.stub_any_instance :session, @session2 do
      user_id = @user2.id

      assert_difference 'User.count', -1 do
        delete api_user_path(user_id), params: nil, headers: nil
      end
      assert_response :success

      assert_not User.find_by(id: user_id)
    end
  end

  test 'DELETE /api/users/:id with token' do
    assert_difference 'User.count', 0 do
      delete api_user_path(@user1.id), params: nil, headers: { 'Authorization' => "Bearer #{@api_token}" }
    end
    assert_response :unauthorized
  end
end
