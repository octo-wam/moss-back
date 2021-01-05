# frozen_string_literal: true

if vote
  json.extract! vote, :id

  json.answerId vote.answer_id
  json.user do
    json.extract! vote.user,
                  :id,
                  :name,
                  :photo
  end
end
