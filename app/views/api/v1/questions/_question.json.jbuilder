# frozen_string_literal: true

if question
  json.extract! question,
                :id,
                :title,
                :description,
                :user_id,
                :user_name

  json.endingDate question.ending_date

  json.answers do
    json.array! question.answers, partial: 'api/v1/answers/answer', as: :answer
  end
end
