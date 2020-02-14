# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  def new_question(recipients)
    @question = params[:question]
    @question_url = "#{ENV['FRONT_BASE_URL']}/question/#{@question.id}"
    finalRecipients = "#{ENV['TEAM_EMAIL_ADDRESS']}#{',' + recipients.join(',') unless recipients.length === 0}"

    mail(to: finalRecipients, subject: '[WAM] Nous avons besoin de ton avis !')
  end
end
