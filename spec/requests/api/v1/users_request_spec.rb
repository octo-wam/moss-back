# frozen_string_literal: true

require 'rails_helper'

describe 'GET /v1/me', type: :request do
  save_current_user

  before do
    get '/api/v1/me', headers: headers_of_logged_in_user
  end

  it 'returns an ok HTTP status' do
    expect(response).to have_http_status :ok
  end

  it 'returns information about the current user' do
    parsed_body = JSON.parse(response.body)
    expect(parsed_body).to eq('id' => current_user_token['sub'],
                              'name' => current_user_token['name'],
                              'email' => current_user_token['email'],
                              'photo' => current_user_token['photo'])
  end
end
