# frozen_string_literal: true

FactoryBot.define do
  factory :mark0, class: 'Mark' do
    title { 'title_0' }
    note { 'note_0' }
    read { false }
    association :user
    association :message, factory: :message0
  end

  factory :mark1, class: 'Mark' do
    title { 'title_1' }
    note { 'note_1' }
    read { false }
    association :user
    association :message, factory: :message1
  end
end
