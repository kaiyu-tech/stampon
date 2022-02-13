# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user
  has_many :marks, dependent: :destroy

  validates :channel_id, uniqueness: { scope: :content_id }

  validates :content, presence: true
  validates :wrote_at, presence: true
end
