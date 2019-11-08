require 'jwt'

class GoogleOauthCallbackController < ApplicationController
  def callback
    response = request.env['omniauth.auth']
    payload = {
      :email => response['info']['email'],
      :exp => response['credentials']['expires_at'],
      :sub => response['extra']['raw_info']['sub']
    }

    token = JWT.encode payload, ENV['SECRET_KEY_BASE'], 'HS256'
    redirect_to "#{ENV['FRONT_BASE_URL']}#access_token=#{token}"
  end
end
