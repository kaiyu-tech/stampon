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

      assert_text 'user_2'
      assert_text 'content_2'
      assert_text '編集'
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

      click_button '編集'

      assert_equal 'StamPon', title
      assert_text 'user_2'
      assert_text 'content_2'
      assert_text '更新'
      assert_text 'キャンセル'
    end
  end

  test 'Success update test with MarkPage component' do
    ApplicationController.stub_any_instance :session, @session do
      visit main_path

      click_button '編集'

      assert_field 'title', with: 'title_1'
      assert_field 'note', with: 'note_1'
      assert_no_field 'title', with: 'updated_title_1'
      assert_no_field 'note', with: 'updated_note_1'

      fill_in 'title', with: 'updated_title_1'
      fill_in 'note', with: 'updated_note_1'

      click_button '更新'

      click_button '編集'

      assert_no_field 'title', with: 'title_1'
      assert_no_field 'note', with: 'note_1'
      assert_field 'title', with: 'updated_title_1'
      assert_field 'note', with: 'updated_note_1'
    end
  end

  test 'Success delete test with MarkPage component' do
    ApplicationController.stub_any_instance :session, @session do
      visit main_path

      assert_equal 'StamPon', title
      assert_text 'user_2'
      assert_text 'content_2'

      click_button '削除'

      assert_no_text 'user_2'
      assert_no_text 'content_2'
    end
  end
end
