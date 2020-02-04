# frozen_string_literal: true

class GoogleOauthCallbackController < ApplicationController
  def callback
    @response = request.env['omniauth.auth']
    redirect_to =  request.env["omniauth.params"]["redirect_to"] || ENV['FRONT_BASE_URL']
    redirect_to "#{redirect_to}#access_token=#{token}"
  end

  private

  def validate_domain
    hosted_domain = @response['extra']['raw_info']['hd']
    render text: 'You must be part of OCTO Technology' unless hosted_domain == 'octo.com'
  end

  def token
    payload = {
      name: @response['info']['name'],
      email: @response['info']['email'],
      exp: @response['credentials']['expires_at'],
      sub: @response['extra']['raw_info']['sub']
    }

    JWT.encode payload, ENV['SECRET_KEY_BASE'], 'HS256'
  end
end
