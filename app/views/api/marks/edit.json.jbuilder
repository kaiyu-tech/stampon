# frozen_string_literal: true

json.user do
  json.partial! 'api/users/user', user: @user
end

json.mark do
  json.partial! 'api/marks/mark', mark: @mark
end
