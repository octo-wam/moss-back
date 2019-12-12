# frozen_string_literal: true

ActionMailer::Base.smtp_settings = if Rails.env.production?
                                     {
                                       user_name: ENV['SENDGRID_USERNAME'],
                                       password: ENV['SENDGRID_PASSWORD'],
                                       address: 'smtp.sendgrid.net',
                                       domain: 'heroku.com',
                                       port: '587',
                                       authentication: :plain
                                     }
                                   else
                                     {
                                       user_name: ENV['MAILTRAP_USERNAME'],
                                       password: ENV['MAILTRAP_PASSWORD'],
                                       address: 'smtp.mailtrap.io',
                                       domain: 'smtp.mailtrap.io',
                                       port: '2525',
                                       authentication: :cram_md5
                                     }
                                   end
