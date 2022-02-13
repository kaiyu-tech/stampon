# frozen_string_literal: true

class User < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :marks, dependent: :destroy

  validates :discord_id, uniqueness: true

  validates :name, presence: true
  validates :discriminator, presence: true
  validates :display_name, presence: true
  validates :avatar, presence: true
  validates :admin, inclusion: { in: [true, false] }
  validates :in_use, inclusion: { in: [true, false] }
end
