# frozen_string_literal: true

require 'rails_helper'

describe 'GET /v1/questions', type: :request do
  let(:question) { create :question }
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
