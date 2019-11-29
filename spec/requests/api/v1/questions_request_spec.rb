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
        title: "mon super titre",
        answers: []
      }, headers: headers_of_logged_in_user

      expect(response).to have_http_status :created
    end

    it'return created question' do
      post "/api/v1/questions/", params: {
        title: "Nom de league?",
        description: "Quel est le nom de la league?",
        endingDate: "2019-11-28T15:59:42.344Z",
        answers: [{title:"WAM", description:"WEB API MOBILE"},{title:"FAME", description:"FRONT API MOBILE EXPERIENCE"}]
      }, headers: headers_of_logged_in_user

      parsed_body = JSON.parse(response.body)
      expect(parsed_body['title']).to eq("Nom de league?")
      expect(parsed_body['answers'].size).to eq(2)
      expect(parsed_body['answers'][0]["title"]).to eq("WAM")
      expect(parsed_body['answers'][0]["description"]).to eq("WEB API MOBILE")
      expect(parsed_body['answers'][1]["title"]).to eq("FAME")
      expect(parsed_body['answers'][1]["description"]).to eq("FRONT API MOBILE EXPERIENCE")
      expect(parsed_body['description']).to eq("Quel est le nom de la league?")
      expect(parsed_body['endingDate']).to eq("2019-11-28T15:59:42.344Z")
    end

    it'return an error when missing title field' do
      post "/api/v1/questions/", params: {
        description: "Quel est le nom de la league?",
        endingDate: "2019-11-28T15:59:42.344Z",
        answers: [{title:"WAM", description:"WEB API MOBILE"},{title:"FAME", description:"FRONT API MOBILE EXPERIENCE"}]
      }, headers: headers_of_logged_in_user

      expect(response).to have_http_status :bad_request
    end

    it'return an error when missing description field' do
      post "/api/v1/questions/", params: {
        title: "Nom de league?",
        endingDate: "2019-11-28T15:59:42.344Z",
        answers: [{title:"WAM", description:"WEB API MOBILE"},{title:"FAME", description:"FRONT API MOBILE EXPERIENCE"}]
      }, headers: headers_of_logged_in_user

      expect(response).to have_http_status :bad_request
    end

    it'return an error when missing endingDate field' do
      post "/api/v1/questions/", params: {
        title: "Nom de league?",
        description: "Quel est le nom de la league?",
        answers: [{title:"WAM", description:"WEB API MOBILE"},{title:"FAME", description:"FRONT API MOBILE EXPERIENCE"}]
      }, headers: headers_of_logged_in_user

      expect(response).to have_http_status :bad_request
    end


    it'return an error when no answer' do
      post "/api/v1/questions/", params: {
        title: "Nom de league?",
        description: "Quel est le nom de la league?",
        endingDate: "2019-11-28T15:59:42.344Z",
      }, headers: headers_of_logged_in_user

      expect(response).to have_http_status :bad_request
    end

    it'return an error when missing title of an answer' do
      post "/api/v1/questions/", params: {
        title: "Nom de league?",
        description: "Quel est le nom de la league?",
        endingDate: "2019-11-28T15:59:42.344Z",
        answers: [{description:"WEB API MOBILE"},{title:"FAME", description:"FRONT API MOBILE EXPERIENCE"}]
      }, headers: headers_of_logged_in_user

      expect(response).to have_http_status :bad_request
    end

    it'return an error when missing description of an answer' do
      post "/api/v1/questions/", params: {
        title: "Nom de league?",
        description: "Quel est le nom de la league?",
        endingDate: "2019-11-28T15:59:42.344Z",
        answers: [{title:"WAM"},{title:"FAME", description:"FRONT API MOBILE EXPERIENCE"}]
      }, headers: headers_of_logged_in_user

      expect(response).to have_http_status :bad_request
    end
  end
end
