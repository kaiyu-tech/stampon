# frozen_string_literal: true

require 'application_system_test_case'
require 'minitest/autorun'
require 'minitest/stub_any_instance'

class MarksTest < ApplicationSystemTestCase
  setup do
    @user = users(:user1)
    @session = { user_id: @user.id }
  end

  test 'Success list view test with MarksPage component' do
    ApplicationController.stub_any_instance :session, @session do
      visit main_path

      assert_equal 'StamPon', title

      assert_text 'user_2_nickname'
      assert_text 'title_1'
      assert_text '削除'
    end
  end

  test 'Failure list view test with MarksPage component' do
    visit main_path

    assert_equal 'StamPon', title

    assert_text 'すたんぽん'
    assert_text 'ログイン'
  end

  test 'Success test transition to MarkPage component' do
    ApplicationController.stub_any_instance :session, @session do
      visit main_path

      find(:xpath, '//*[@id="app"]//main//table/tbody/tr[1]/td[3]', text: 'title_1').click

      assert_field 'タイトル(任意)', with: 'title_1'
      assert_field 'ノート(任意)', with: 'note_1'
      assert_text 'キャンセル'
      assert_text '更新'
    end
  end

  test 'Success update test with MarkPage component' do
    ApplicationController.stub_any_instance :session, @session do
      visit main_path

      find(:xpath, '//*[@id="app"]//main//table/tbody/tr[1]/td[3]', text: 'title_1').click

      assert_field 'タイトル(任意)', with: 'title_1'
      assert_field 'ノート(任意)', with: 'note_1'
      assert_no_field 'タイトル(任意)', with: 'updated_title_1'
      assert_no_field 'ノート(任意)', with: 'updated_note_1'

      fill_in 'タイトル(任意)', with: 'updated_title_1'
      fill_in 'ノート(任意)', with: 'updated_note_1'

      click_button '更新'

      find(:xpath, '//*[@id="app"]//main//table/tbody/tr[1]/td[3]', text: 'title_1').click

      assert_no_field 'タイトル(任意)', with: 'title_1'
      assert_no_field 'ノート(任意)', with: 'note_1'
      assert_field 'タイトル(任意)', with: 'updated_title_1'
      assert_field 'ノート(任意)', with: 'updated_note_1'
    end
  end

  test 'Success delete test with MarkPage component' do
    ApplicationController.stub_any_instance :session, @session do
      visit main_path

      assert_text 'user_2_nickname'
      assert_text 'title_1'

      click_button '削除'
      page.accept_alert

      assert_no_text 'user_2_nickname'
      assert_no_text 'title_1'
    end
  end

  test 'Success logout test' do
    ApplicationController.stub_any_instance :session, @session do
      user_id = @session[:user_id]

      visit main_path

      find('#user-icon').click
      find('.v-list-item__title', text: 'ログアウト').click

      assert_text 'すたんぽん'
      assert_text 'ログイン'

      assert user_id, @session[:user_id]
    end
  end

  test 'Success delete account test' do
    ApplicationController.stub_any_instance :session, @session do
      visit main_path

      find('#user-icon').click
      find('.v-list-item__title', text: 'アカウント削除').click
      page.accept_alert

      assert_text 'すたんぽん'
      assert_text 'ログイン'

      assert_nil @session[:user_id]
    end
  end
end
