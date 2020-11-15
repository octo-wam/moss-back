# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  SENDER_EMAIL = ENV.fetch('APPLICATION_EMAIL_ADDRESS')
  SENDER = "MOSS <#{SENDER_EMAIL}>"
  default from: SENDER

  layout 'mailer'
end
