# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user
  has_many :marks, dependent: :destroy
end
