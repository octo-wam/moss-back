# frozen_string_literal: true

class GoogleOauthCallbackController < ApplicationController
  def callback
    @google_oauth2_response = request.env['omniauth.auth']
    validate_email_domain
    upsert_user
    if redirect_url_allowed?(request.env)
      redirect_to front_app_url_with_token(request.env)
    else
      render body: "Access Token : #{token}"
    end
  end

  private

  def validate_email_domain
    hosted_domain = @response['extra']['raw_info']['hd']
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

  def redirect_url_allowed?(env)
    redirect_url = env['omniauth.params'].fetch('redirect_to', '')
    redirect_url.start_with?(ENV['FRONT_BASE_URL'])
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
