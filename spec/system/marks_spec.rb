# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Marks', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  scenario 'Log in to view the bookmarks list page', js: true do
    sign_in_as(@user) { visit root_path }

    visit marks_path

    expect(page).to have_title 'StamPon'
    expect(page).to have_content 'user'
    expect(page).to have_content 'まだデータがありません😢！Discordでブックマーク発言したい発言に「気になる」か「👀」スタンプを押そう！'
  end

  scenario 'Redirect to login page if not logged in.', js: true do
    visit marks_path

    expect(page).to have_title 'StamPon'
    expect(page).to have_content 'すたんぽん'
    expect(page).to have_content 'ログイン'
  end

  scenario 'Click on the summary to display the bookmark details page', js: true do
    mark = FactoryBot.create(:mark0)

    sign_in_as(mark.user) { visit root_path }

    visit marks_path

    find(:xpath, '//*[@id="app"]//main//table/tbody/tr/td[2]/div[1]', text: 'title_0').click

    expect(page).to have_field 'タイトル(任意)', with: 'title_0'
    expect(page).to have_field 'ノート(任意)', with: 'note_0'

    expect(page).to have_content 'キャンセル'
    expect(page).to have_content '更新'
  end

  scenario 'Edit the title and note on the bookmark detail page', js: true do
    mark = FactoryBot.create(:mark0)

    sign_in_as(mark.user) { visit root_path }

    visit marks_path

    find(:xpath, '//*[@id="app"]//main//table/tbody/tr/td[2]/div[1]', text: 'title_0').click

    expect(page).to have_field 'タイトル(任意)', with: 'title_0'
    expect(page).to have_field 'ノート(任意)', with: 'note_0'
    expect(page).to_not have_field 'タイトル(任意)', with: 'updated_title_0'
    expect(page).to_not have_field 'ノート(任意)', with: 'updated_note_0'

    fill_in 'タイトル(任意)', with: 'updated_title_0'
    fill_in 'ノート(任意)', with: 'updated_note_0'

    click_button '更新'

    find(:xpath, '//*[@id="app"]//main//table/tbody/tr/td[2]/div[1]', text: 'updated_title_0').click

    expect(page).to_not have_field 'タイトル(任意)', with: 'title_0'
    expect(page).to_not have_field 'ノート(任意)', with: 'note_0'
    expect(page).to have_field 'タイトル(任意)', with: 'updated_title_0'
    expect(page).to have_field 'ノート(任意)', with: 'updated_note_0'
  end

  scenario 'Delete bookmarks', js: true do
    mark = FactoryBot.create(:mark0)

    sign_in_as(mark.user) { visit root_path }

    visit marks_path

    expect(page).to have_content 'title_0'

    click_button '削除'
    page.accept_alert

    expect(page).to_not have_content 'user_0_nickname'
    expect(page).to_not have_content 'title_0'
  end

  scenario 'Logging out', js: true do
    sign_in_as(@user) { visit root_path }

    visit marks_path

    find('#user-icon').click
    find('.v-list-item__title', text: 'ログアウト').click

    expect(page).to have_content 'すたんぽん'
    expect(page).to have_content 'Discord でログイン'

    assert User.find(@user.id)
  end

  scenario 'Delete user account', js: true do
    other_user = FactoryBot.create(:other_user)
    message = FactoryBot.create(:message0, user: @user)
    FactoryBot.create(:mark0, user: other_user, message: message)

    sign_in_as(@user) { visit root_path }

    visit marks_path

    find('#user-icon').click
    find('.v-list-item__title', text: 'アカウント削除').click
    page.accept_alert

    expect(page).to have_content 'すたんぽん'
    expect(page).to have_content 'Discord でログイン'

    expect(User.find_by(id: @user.id).in_use).to be false

    sign_in_as(other_user) { visit root_path }

    visit marks_path

    find('#user-icon').click
    find('.v-list-item__title', text: 'アカウント削除').click
    page.accept_alert

    expect(page).to have_content 'すたんぽん'
    expect(page).to have_content 'Discord でログイン'

    expect(User.find_by(id: other_user.id)).to be_nil

    expect(User.find_by(id: @user.id)).to be_nil
  end
end
