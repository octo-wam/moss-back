# frozen_string_literal: true

if answer
  json.extract! answer,
                :id,
                :title,
                :description
end
