# frozen_string_literal: true

if @current_user
  json.id @current_user['sub']
  json.name @current_user['name']
  json.email @current_user['email']
end
