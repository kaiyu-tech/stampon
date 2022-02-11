# frozen_string_literal: true

require 'test_helper'

Webdrivers::Chromedriver.update

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  HEADED = ENV['HEADED'] || false
  VUEJS_TIME_OUT = (ENV['VUEJS_TIME_OUT'] || 3).to_i

  if HEADED
    driven_by :selenium_chrome, screen_size: [1400, 1400]
  else
    driven_by :selenium_chrome_headless, screen_size: [1400, 1400], options: { args: ['no-sandbox', 'disable-gpu', 'lang=ja-JP'] }
  end
end
