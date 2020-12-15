# frozen_string_literal: true

if @decoded_token
  json.id @decoded_token['sub']
  json.name @decoded_token['name']
  json.email @decoded_token['email']
  json.photo @decoded_token['photo']
end
