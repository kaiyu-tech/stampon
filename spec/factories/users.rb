# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    discord_id { Faker::Number.number(digits: 18) }
    name { 'user' }
    discriminator { Faker::Number.number(digits: 4) }
    display_name { 'user_nickname' }
    avatar { Faker::Number.hexadecimal(digits: 32) }
    admin { false }
    in_use { true }
    expires_at { nil }

    factory :admin do
      discord_id { Faker::Number.number(digits: 18) }
      name { 'admin' }
      discriminator { Faker::Number.number(digits: 4) }
      display_name { 'admin_nickname' }
      avatar { Faker::Number.hexadecimal(digits: 32) }
      admin { true }
    end

    factory :other_user do
      discord_id { Faker::Number.number(digits: 18) }
      name { 'other_user' }
      discriminator { Faker::Number.number(digits: 4) }
      display_name { 'other_user_nickname' }
      avatar { Faker::Number.hexadecimal(digits: 32) }
    end

    factory :author do
      discord_id { Faker::Number.number(digits: 18) }
      name { 'author' }
      discriminator { Faker::Number.number(digits: 4) }
      display_name { 'author_nickname' }
      avatar { Faker::Number.hexadecimal(digits: 32) }
    end
  end
end
