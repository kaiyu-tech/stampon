# frozen_string_literal: true

class User < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :marks, dependent: :destroy
end
