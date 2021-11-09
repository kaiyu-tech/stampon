# frozen_string_literal: true

require 'application_system_test_case'

class SessionsTest < ApplicationSystemTestCase
  test 'GET /' do
    visit root_path
    assert_equal 'Stampon', title
    assert_link 'Login', href: 'https://discord.com/oauth2/authorize?' \
                               "client_id=#{ENV['DISCORD_CLIENT_ID']}&" \
                               "redirect_uri=#{CGI.escape(ENV['DISCORD_REDIRECT_URI'])}&" \
                               'response_type=code&' \
                               "scope=#{ENV['DISCORD_SCOPE']}"
    click_link 'Login'
    assert_text 'メールアドレスまたは電話番号'
    assert_text 'パスワード'
    assert_text 'ログイン'
  end
end
