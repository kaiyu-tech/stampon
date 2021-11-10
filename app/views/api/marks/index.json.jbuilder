# frozen_string_literal: true

json.user do
  json.partial! 'api/users/user', user: @user
end

json.marks do
  json.array! @marks do |mark|
    json.partial! 'api/marks/mark', mark: mark
  end
end
