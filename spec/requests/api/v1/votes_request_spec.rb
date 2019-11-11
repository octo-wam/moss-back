# frozen_string_literal: true

require 'rails_helper'

describe 'GET /v1/questions/:id/votes', type: :request do
  let(:question) { create :question }
  let(:answer) { create :answer, question: question }
  let!(:vote) { create :vote, answer: answer }

  before do
    get "/api/v1/questions/#{question.id}/votes", headers: headers_of_logged_in_user
  end

  it 'returns an ok HTTP status' do
    expect(response).to have_http_status :ok
  end

  it 'returns an array with one vote' do
    parsed_body = JSON.parse(response.body)
    expect(parsed_body.size).to eq(1)
    expect(parsed_body.first['id']).to eq(vote.id)
    expect(parsed_body.first['answerId']).to eq(answer.id)
  end
end
