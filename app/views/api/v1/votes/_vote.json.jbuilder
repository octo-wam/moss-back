# frozen_string_literal: true

if vote
  json.extract! vote, :id

  json.answerId vote.answer_id
  json.user do
    json.id vote.user_id
    json.name vote.user.name
    json.photo vote.user.photo
  end
end
