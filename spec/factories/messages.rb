# frozen_string_literal: true

FactoryBot.define do
  factory :message0, class: 'Message' do
    channel_id { Faker::Number.number(digits: 18) }
    content_id { Faker::Number.number(digits: 18) }
    content { 'content_0' }
    wrote_at { Time.current }
    association :user, factory: :author
  end

  factory :message1, class: 'Message' do
    channel_id { Faker::Number.number(digits: 18) }
    content_id { Faker::Number.number(digits: 18) }
    content { 'content_1' }
    wrote_at { Time.current }
    association :user, factory: :author
  end
end
