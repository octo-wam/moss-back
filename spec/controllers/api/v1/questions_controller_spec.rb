# frozen_string_literal: true

require 'rails_helper'
require 'jwt'

RSpec.describe Api::V1::QuestionsController, type: :controller do
  describe 'GET #index' do
    let(:token) {
      JWT.encode({}, ENV['SECRET_KEY_BASE'], 'HS256')
    }
    let!(:question) { create :question }
    let!(:answer) { create :answer, question: question }

    before {
      request.headers['Authorization'] = "Bearer #{token}"
      get :index, format: :json
    }

    it('returns http success') { expect(response).to have_http_status(:success) }
    # it('returns an array with one question') do
    #   expect(JSON.parse(response.body)[0]['title']).to eq(question.title)
    #   expect(JSON.parse(response.body)[0]['answers']).not_to be_nil
    #   expect(JSON.parse(response.body)[0]['answers'][0]['title']).to eq(answer.title)
    # end
  end
end
