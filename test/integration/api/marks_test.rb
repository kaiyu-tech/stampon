# frozen_string_literal: true

require 'test_helper'

class Api::MarksTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user1)
    @author = users(:user2)

    @api_token = ENV['STAMPON_API_TOKEN']
    @invalidapi_token = 'acCeSS_10KEn-uNS10pa61E_tuKE.3Zu'

    @discord_params = { discord:
                          { channel_id: Faker::Number.number(digits: 18),
                            content_id: Faker::Number.number(digits: 18),
                            user_id: @user.discord_id,
                            user_name: @user.name,
                            user_avatar: @user.avatar,
                            author_id: @author.discord_id,
                            author_name: @author.name,
                            author_avatar: @author.avatar,
                            content: 'これはすごい有益な情報🐣を含んだ発言です。' } }
  end

  test 'GET /api/marks' do
    get api_marks_path, params: nil, headers: { 'Authorization' => "Bearer #{@api_token}" }
    assert_response :unauthorized
  end

  test 'POST /api/marks' do
    assert_difference 'Mark.count', +1 do
      post api_marks_path, params: @discord_params, headers: { 'Authorization' => "Bearer #{@api_token}" }
    end
    assert_response :success
  end

  test 'POST /api/marks with invalid token' do
    post api_marks_path, params: @discord_params, headers: { 'Authorization' => "Bearer #{@invalid_api_token}" }
    assert_response :unauthorized
  end

  test 'GET /api/marks/:id/edit' do
    get edit_api_mark_path(@user.marks.first.id), params: nil, headers: { 'Authorization' => "Bearer #{@api_token}" }
    assert_response :unauthorized
  end

  test 'PATCH /api/marks/:id' do
    patch api_mark_path(@user.marks.first.id), params: { title: 'updated_title', note: 'updated_note' },
                                               headers: { 'Authorization' => "Bearer #{@api_token}" }
    assert_response :unauthorized
  end

  test 'DELETE /api/marks/:id' do
    delete api_mark_path(@user.marks.first.id), params: nil, headers: { 'Authorization' => "Bearer #{@api_token}" }
    assert_response :unauthorized
  end
end
