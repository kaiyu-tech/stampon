# frozen_string_literal: true

Rack::MiniProfiler.config.position = 'bottom-left' if Rails.env.development?
