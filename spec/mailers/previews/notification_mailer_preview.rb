# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview
  def new_question
    NotificationMailer.with(question: Question.first).new_question
  end
end
