# frozen_string_literal: true

require 'application_system_test_case'
require 'minitest/autorun'
require 'minitest/stub_any_instance'

class MarksTest < ApplicationSystemTestCase
  setup do
    @user1 = users(:user1)
    @user2 = users(:user2)

    @session1 = { user_id: @user1.id }
    @user1.update!(expires_at: 3.hours.from_now)
    @session2 = { user_id: @user2.id }
    @user2.update!(expires_at: 3.hours.from_now)
  end

  test 'Success list view test with MarksPage component' do
    ApplicationController.stub_any_instance :session, @session1 do
      visit marks_path

      assert_equal 'StamPon', title

      Timeout.timeout(VUEJS_TIME_OUT) do
        loop until page.has_text?('title_1')
      end

      assert_text 'title_1'
      assert_text '削除'
    end
  end

  test 'Failure list view test with MarksPage component' do
    visit marks_path

    assert_equal 'StamPon', title

    assert_text 'すたんぽん'
    assert_text 'ログイン'
  end

  test 'Success test transition to MarkPage component' do
    ApplicationController.stub_any_instance :session, @session1 do
      visit marks_path

      find(:xpath, '//*[@id="app"]//main//table/tbody/tr/td[2]/div[1]', text: 'title_1').click

      assert_field 'タイトル(任意)', with: 'title_1'
      assert_field 'ノート(任意)', with: 'note_1'
      assert_text 'キャンセル'
      assert_text '更新'
    end
  end

  test 'Success update test with MarkPage component' do
    ApplicationController.stub_any_instance :session, @session1 do
      visit marks_path

      find(:xpath, '//*[@id="app"]//main//table/tbody/tr/td[2]/div[1]', text: 'title_1').click

      assert_field 'タイトル(任意)', with: 'title_1'
      assert_field 'ノート(任意)', with: 'note_1'
      assert_no_field 'タイトル(任意)', with: 'updated_title_1'
      assert_no_field 'ノート(任意)', with: 'updated_note_1'

      fill_in 'タイトル(任意)', with: 'updated_title_1'
      fill_in 'ノート(任意)', with: 'updated_note_1'

      click_button '更新'

      find(:xpath, '//*[@id="app"]//main//table/tbody/tr/td[2]/div[1]', text: 'updated_title_1').click

      assert_no_field 'タイトル(任意)', with: 'title_1'
      assert_no_field 'ノート(任意)', with: 'note_1'
      assert_field 'タイトル(任意)', with: 'updated_title_1'
      assert_field 'ノート(任意)', with: 'updated_note_1'
    end
  end

  test 'Success delete test with MarkPage component' do
    ApplicationController.stub_any_instance :session, @session1 do
      visit marks_path

      Timeout.timeout(VUEJS_TIME_OUT) do
        loop until page.has_text?('title_1')
      end

      assert_text 'title_1'

      click_button '削除'
      page.accept_alert

      assert_no_text 'user_2_nickname'
      assert_no_text 'title_1'
    end
  end

  test 'Success logout test' do
    ApplicationController.stub_any_instance :session, @session1 do
      user_id = @session1[:user_id]

      visit marks_path

      find('#user-icon').click
      find('.v-list-item__title', text: 'ログアウト').click

      assert_text 'すたんぽん'
      assert_text 'ログイン'

      assert_nil @session1[:user_id]
      assert User.find(user_id)
    end
  end

  test 'Success delete account test' do
    ApplicationController.stub_any_instance :session, @session1 do
      user_id = @session1[:user_id]

      visit marks_path

      find('#user-icon').click
      find('.v-list-item__title', text: 'アカウント削除').click
      page.accept_alert

      assert_text 'すたんぽん'
      assert_text 'ログイン'

      assert_nil @session1[:user_id]
      assert_not User.find_by(id: user_id).in_use
    end
    ApplicationController.stub_any_instance :session, @session2 do
      user2_id = @session2[:user_id]

      visit marks_path

      find('#user-icon').click
      find('.v-list-item__title', text: 'アカウント削除').click
      page.accept_alert

      assert_text 'すたんぽん'
      assert_text 'ログイン'

      assert_nil @session2[:user_id]
      assert_nil User.find_by(id: user2_id)

      user1_id = @session1[:user_id]
      assert_nil User.find_by(id: user1_id)
    end
  end
end
