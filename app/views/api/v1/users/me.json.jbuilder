# frozen_string_literal: true

if @current_user
  json.extract! @current_user,
                :id,
                :name,
                :email,
                :photo
end
