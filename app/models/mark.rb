# frozen_string_literal: true

class Mark < ApplicationRecord
  belongs_to :user
  belongs_to :message
end
