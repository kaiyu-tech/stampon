# frozen_string_literal: true

json.user 'api/users/user', user: @user

json.marks @marks do |mark|
  json.partial! 'api/marks/mark', mark: mark
end
