# frozen_string_literal: true

class GoogleOauthCallbackController < ApplicationController
  def callback
    @response = request.env['omniauth.auth']
    redirect_to front_app_url_with_token(request.env)
  end

  private

  def front_app_url_with_token(env)
    if env['omniauth.params']['redirect_to'].starts_with? ENV['FRONT_BASE_URL']
      front_app_url = env['omniauth.params']['redirect_to']
    end
    front_app_url ||= ENV['FRONT_BASE_URL']
    "#{front_app_url}#access_token=#{token}"
  end

  def validate_domain
    hosted_domain = @auth_info['extra']['raw_info']['hd']
    render text: 'You must be part of OCTO Technology' unless hosted_domain == 'octo.com'
  end

  def upsert_user
    user = User.find_or_initialize_by(id: @auth_info['extra']['raw_info']['sub'])
    user.assign_attributes(
      name: @auth_info['info']['name'],
      email: @auth_info['info']['email'],
      photo: @auth_info['extra']['raw_info']['picture']
    )
    user.save!
  end

  def token
    payload = {
      name: @auth_info['info']['name'],
      email: @auth_info['info']['email'],
      photo: @auth_info['extra']['raw_info']['picture'],
      exp: @auth_info['credentials']['expires_at'],
      sub: @auth_info['extra']['raw_info']['sub']
    }

    JWT.encode payload, ENV['SECRET_KEY_BASE'], 'HS256'
  end
end
