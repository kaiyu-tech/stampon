# frozen_string_literal: true

require 'test_helper'

class API::MarksTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user1)

    @api_token = ENV['STAMPON_API_TOKEN']
    @invalid_api_token = 'acCeSS_10KEn-uNS10pa61E_tuKE.3Zu'

    @session = { user_id: @user.id }
    @user.update!(expires_at: Time.current + 3.hours)

    @discord_params = discord_params
  end

  def discord_params
    { discord: { channel_id: Faker::Number.number(digits: 18),
                 content_id: Faker::Number.number(digits: 18),
                 user_id: @user.discord_id,
                 user_name: @user.name,
                 user_discriminator: @user.discriminator,
                 user_display_name: @user.display_name,
                 user_avatar: @user.avatar,
                 author_id: Faker::Number.number(digits: 18),
                 author_name: 'author',
                 author_discriminator: Faker::Number.number(digits: 4),
                 author_display_name: 'author_nickname',
                 author_avatar: Faker::Number.hexadecimal(digits: 32),
                 content: 'これはすごい有益な情報🐣を含んだ発言です。',
                 wrote_at: Time.current.strftime('%s%L') } }
  end

  test 'GET /api/marks with token' do
    get api_marks_path, params: nil, headers: { 'Authorization' => "Bearer #{@api_token}" }
    assert_response :unauthorized
  end

  test 'POST /api/marks with token' do
    assert_difference 'Mark.count', +1 do
      post api_marks_path, params: @discord_params, headers: { 'Authorization' => "Bearer #{@api_token}" }
    end
    assert_response :success

    assert User.find_by(discord_id: @discord_params[:discord][:author_id])
  end

  test 'POST /api/marks with invalid token' do
    post api_marks_path, params: @discord_params, headers: { 'Authorization' => "Bearer #{@invalid_api_token}" }
    assert_response :unauthorized
  end

  test 'GET /api/marks/:id/edit with token' do
    get edit_api_mark_path(@user.marks.first.id), params: nil, headers: { 'Authorization' => "Bearer #{@api_token}" }
    assert_response :unauthorized
  end

  test 'PATCH /api/marks/:id with token' do
    patch api_mark_path(@user.marks.first.id), params: { title: 'updated_title', note: 'updated_note' },
                                               headers: { 'Authorization' => "Bearer #{@api_token}" }
    assert_response :unauthorized
  end

  test 'DELETE /api/marks/:id with token' do
    delete api_mark_path(@user.marks.first.id), params: nil, headers: { 'Authorization' => "Bearer #{@api_token}" }
    assert_response :unauthorized
  end

  test 'PATCH /api/marks/:id with session' do
    ApplicationController.stub_any_instance :session, @session do
      mark_id = @user.marks.first.id

      patch api_mark_path(mark_id), params: { title: 'updated_title', note: 'updated_note' }, headers: nil
      assert_response :success

      assert_equal 'updated_title', Mark.find(mark_id).title
      assert_equal 'updated_note', Mark.find(mark_id).note
    end
  end

  test 'DELETE /api/marks/:id with session' do
    ApplicationController.stub_any_instance :session, @session do
      mark_id = @user.marks.first.id

      assert_difference 'Mark.count', -1 do
        delete api_mark_path(mark_id), params: nil, headers: nil
      end
      assert_response :success

      assert_not Mark.find_by(id: mark_id)
    end
  end
end
