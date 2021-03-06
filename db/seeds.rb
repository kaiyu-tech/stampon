# frozen_string_literal: true

User.destroy_all

ActiveRecord::Base.connection.tables.each do |table|
  ActiveRecord::Base.connection.reset_pk_sequence!(table)
end

now = Time.current

admin = User.create!(discord_id: Faker::Number.number(digits: 18),
                     name: 'admin',
                     discriminator: Faker::Number.number(digits: 4),
                     display_name: 'admin_nickname',
                     avatar: Faker::Number.hexadecimal(digits: 32),
                     admin: true,
                     in_use: true,
                     expires_at: nil,
                     created_at: now,
                     updated_at: now)

message = Message.create!(channel_id: Faker::Number.number(digits: 18),
                          content_id: Faker::Number.number(digits: 18),
                          content: 'content',
                          wrote_at: now,
                          user: admin,
                          created_at: now,
                          updated_at: now)

Mark.create!(user: admin,
             message: message,
             title: 'title',
             note: 'note',
             read: false,
             created_at: now,
             updated_at: now)

users = []
0.upto(2) do |n|
  users << User.create!(discord_id: Faker::Number.number(digits: 18),
                        name: "user_#{n + 1}",
                        discriminator: Faker::Number.number(digits: 4),
                        display_name: "user_#{n + 1}_nickname",
                        avatar: Faker::Number.hexadecimal(digits: 32),
                        admin: false,
                        in_use: true,
                        expires_at: nil,
                        created_at: now + n.minutes,
                        updated_at: now + n.minutes)
end

authors = []
0.upto(2) do |n|
  authors << User.create!(discord_id: Faker::Number.number(digits: 18),
                          name: "author_#{n + 1}",
                          discriminator: Faker::Number.number(digits: 4),
                          display_name: "author_#{n + 1}_nickname",
                          avatar: Faker::Number.hexadecimal(digits: 32),
                          admin: false,
                          in_use: false,
                          expires_at: nil,
                          created_at: now + n.minutes,
                          updated_at: now + n.minutes)
end

messages = []
0.upto(2) do |n|
  messages << Message.create!(channel_id: Faker::Number.number(digits: 18),
                              content_id: Faker::Number.number(digits: 18),
                              content: "content_#{n + 1}",
                              wrote_at: now + n.minutes,
                              user: authors[n],
                              created_at: now + n.minutes,
                              updated_at: now + n.minutes)
end

0.upto(2) do |n|
  Mark.create!(user: users[n],
               message: messages[n],
               title: "title_#{n + 1}",
               note: "note_#{n + 1}",
               read: false,
               created_at: now + n.minutes,
               updated_at: now + n.minutes)
end
