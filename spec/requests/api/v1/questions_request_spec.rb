# frozen_string_literal: true

require 'rails_helper'

describe 'Questions', type: :request do
  let(:question) { create :question }

  describe 'GET /v1/questions' do
    let!(:answer) { create :answer, question: question }

    before do
      get '/api/v1/questions', headers: headers_of_logged_in_user
    end

    it 'returns an ok HTTP status' do
      expect(response).to have_http_status :ok
    end

    it 'returns an array with one question containing one answer' do
      parsed_body = JSON.parse(response.body)
      expect(parsed_body.size).to eq(1)
      expect(parsed_body.first['title']).to eq(question.title)
      expect(parsed_body.first['answers'].size).to eq(1)
      expect(parsed_body.first['answers'].first['title']).to eq(answer.title)
    end
  end

  describe 'GET /v1/questions/:id' do
    let!(:answer) { create :answer, question: question }

    before do
      get "/api/v1/questions/#{question.id}", headers: headers_of_logged_in_user
    end

    it 'returns an ok HTTP status' do
      expect(response).to have_http_status :ok
    end

    it 'returns the question with its answers' do
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['title']).to eq(question.title)
      expect(parsed_body['answers'].size).to eq(1)
      expect(parsed_body['answers'].first['title']).to eq(answer.title)
    end
  end

  describe 'POST /v1/questions/' do
    it 'create a question with POST request' do
      post "/api/v1/questions/", params: {
        title: "mon super titre"
      }, headers: headers_of_logged_in_user

      expect(response).to have_http_status :created
    end

    it'return created question' do
      post "/api/v1/questions/", params: {
        title: "mon super titre"
      }, headers: headers_of_logged_in_user

      parsed_body = JSON.parse(response.body)

      expect(parsed_body).to eq({"title"=>"mon super titre"})
    end
  end
end
