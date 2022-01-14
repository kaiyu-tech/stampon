# frozen_string_literal: true

require 'test_helper'

Webdrivers::Chromedriver.update

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase

  HEADLESS = (ENV['HEADLESS'] || 1).to_i 
  VUEJS_TIME_OUT = (ENV['VUEJS_TIME_OUT'] || 5).to_i

  if HEADLESS
    driven_by :selenium_chrome_headless, screen_size: [1400, 1400]
  else
    driven_by :selenium_chrome, screen_size: [1400, 1400]
  end
end
