# frozen_string_literal: true

namespace :clean do
  task questions_and_answers: :environment do
    Answer.delete_all
    Question.delete_all
  end
end
