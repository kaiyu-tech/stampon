# frozen_string_literal: true

require 'test_helper'

Webdrivers::Chromedriver.update

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  HEADED = ENV['HEADED'] || false
  VUEJS_TIME_OUT = (ENV['VUEJS_TIME_OUT'] || 3).to_i

  if HEADED
    driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
  else
    driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400] do |options|
      options.add_argument('--no-sandbox')
      options.add_argument('--disable-gpu')
      options.add_argument('--lang=ja-JP')
    end
  end
end
