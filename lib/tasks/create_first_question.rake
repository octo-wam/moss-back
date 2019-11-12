# frozen_string_literal: true

namespace :init do
  task create_first_question: :environment do
    question = Question.create!(
      title: 'Quel nom pour la league ?',
      description: 'Il faut choisir :)',
      ending_date: DateTime.new(2019, 11, 12, 12)
    )
    Answer.create!(
      title: 'WAM',
      description: 'Web Application Mobile',
      question: question
    )
    Answer.create!(
      title: 'IDEA',
      description: 'Interfaces, Digital Experiences & API',
      question: question
    )
    Answer.create!(
      title: 'FAME',
      description: 'Front Api Mobile Experience',
      question: question
    )
  end
end
