# frozen_string_literal: true

class GoogleOauthCallbackController < ApplicationController
  def callback
    @google_oauth2_response = request.env['omniauth.auth']
    validate_domain
    upsert_user
    redirect_to front_app_url_with_token(request.env)
  end

  private

  def validate_domain
    hosted_domain = @google_oauth2_response['extra']['raw_info']['hd']
    render text: 'You must be part of OCTO Technology' unless hosted_domain == 'octo.com'
  end

  def upsert_user
    user = User.find_or_initialize_by(id: @google_oauth2_response['extra']['raw_info']['sub'])
    user.assign_attributes(
      name: @google_oauth2_response['info']['name'],
      email: @google_oauth2_response['info']['email'],
      photo: @google_oauth2_response['extra']['raw_info']['picture']
    )
    user.save!
  end

  def front_app_url_with_token(env)
    if env.dig('omniauth.params', 'redirect_to')&.start_with? ENV['FRONT_BASE_URL']
      front_app_url = env['omniauth.params']['redirect_to']
    end
    front_app_url ||= ENV['FRONT_BASE_URL']
    "#{front_app_url}#access_token=#{token}"
  end

  def token
    payload = {
      name: @google_oauth2_response['info']['name'],
      email: @google_oauth2_response['info']['email'],
      photo: @google_oauth2_response['extra']['raw_info']['picture'],
      exp: @google_oauth2_response['credentials']['expires_at'],
      sub: @google_oauth2_response['extra']['raw_info']['sub']
    }

    JWT.encode payload, ENV['SECRET_KEY_BASE'], 'HS256'
  end
end
