# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  def new_question
    @question = params[:question]
    @question_url = "#{ENV.fetch('FRONT_BASE_URL')}/question/#{@question.id}"
    mail(to: ENV['TEAM_EMAIL_ADDRESS'], subject: '[WAM] Nous avons besoin de ton avis !')
  end
end
