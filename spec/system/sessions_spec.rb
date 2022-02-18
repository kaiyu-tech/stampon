# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  # Discordでログインする
  scenario 'sign in with discord', js: true do
    visit root_path

    expect(page).to have_title 'StamPon'
    expect(page).to have_link 'Discord でログイン', href: 'https://discord.com/oauth2/authorize?' \
                                                     "client_id=#{ENV['DISCORD_CLIENT_ID']}&" \
                                                     "redirect_uri=#{CGI.escape(ENV['DISCORD_REDIRECT_URI'])}&" \
                                                     'response_type=code&' \
                                                     "scope=#{ENV['DISCORD_SCOPE']}"

    click_link 'Discord でログイン'

    expect(page).to have_content 'メールアドレスまたは電話番号'
    expect(page).to have_content 'パスワード'
    expect(page).to have_content 'ログイン'
  end
end
