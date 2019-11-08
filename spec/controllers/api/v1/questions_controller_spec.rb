# frozen_string_literal: true

require 'rails_helper'
require 'jwt'

RSpec.describe Api::V1::QuestionsController, type: :controller do
  describe 'GET #index' do
    let(:token) {
      JWT.encode({}, ENV['SECRET_KEY_BASE'], 'HS256')
    }
    before {
      request.headers['Authorization'] = "Bearer #{token}"
      get :index, format: :json
    }

    it('returns http success') { expect(response).to have_http_status(:success) }
    it('retunrs an array with one question') do
      expect(JSON.parse(response.body)).to eq([
        {
          "id" => 1,
          "title" => "Quel nom pour la league?",
          "description" => "Il faut choisir",
          "endingDate" => "2019-11-08T13:45:01+00:00",
          "answers" => [
            {
              "id" => 1,
              "title" => "WAM",
              "description" => "dgsdgd"
            },
            {
              "id" => 2,
              "title" => "IDEA",
              "description" => "dgsdgd"
            },
            {
              "id" => 3,
              "title" => "FAME",
              "description" => "dgsdgd"
            }
          ]
        }
      ])
    end
  end
end
