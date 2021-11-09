# frozen_string_literal: true

require 'test_helper'

Webdrivers::Chromedriver.update

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  if ENV['CI'] # True in GitHub Actions.
    driven_by :selenium, using: :chrome_headless, screen_size: [1400, 1400]
  else
    driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
  end
end
