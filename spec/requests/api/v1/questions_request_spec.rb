# frozen_string_literal: true

require 'rails_helper'

describe 'Questions', type: :request do
  let(:user) { create :user }
  let(:question) { create :question, user: user }

  describe 'GET /v1/questions' do
    describe 'simple request' do
      let!(:answer) { create :answer, question: question }

      before do
        get '/api/v1/questions',  headers: headers_of_logged_in_user
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
        expect(parsed_body.first['user']).to eq('id' => question.user_id,
                                                'name' => user.name,
                                                'photo' => user.photo)
      end
    end

    context 'request with sort=created_at parameter' do
      let!(:params) { { sort: 'created_at' } }

      let!(:recent_question) { create :question, created_at: 1.hour.ago }
      let!(:old_question) { create :question, created_at: 1.year.ago }

      before do
        question.update created_at: 1.day.ago

        get '/api/v1/questions', params: params, headers: headers_of_logged_in_user
      end

      it 'returns an array with three questions sorted by date asc' do
        parsed_body = JSON.parse(response.body)
        question_ids = parsed_body.map { |q| q['id'] }

        expect(question_ids).to eq([old_question.id, question.id, recent_question.id])
      end
    end

    context 'request with sort=created_at:desc parameter' do
      let!(:params) { { sort: 'created_at:desc' } }

      let!(:recent_question) { create :question, created_at: 1.hour.ago }
      let!(:old_question) { create :question, created_at: 1.year.ago }

      before do
        question.update created_at: 1.day.ago

        get '/api/v1/questions', params: params, headers: headers_of_logged_in_user
      end

      it 'returns an array with three questions sorted by date desc' do
        parsed_body = JSON.parse(response.body)
        question_ids = parsed_body.map { |q| q['id'] }

        expect(question_ids).to eq([recent_question.id, question.id, old_question.id])
      end
    end

    context 'request with sort=created_at:desc,title parameter' do
      let!(:params) { { sort: 'created_at:desc,title' } }

      let(:identical_date) { 1.hour.ago.to_date }
      let!(:question_starting_with_w) { create :question, title: 'What is the main purpose of a lockdown?', created_at: identical_date }
      let!(:question_starting_with_o) { create :question, title: 'On which date will we be allowed to go out?', created_at: identical_date }

      before do
        question.update created_at: 1.day.ago

        get '/api/v1/questions', params: params, headers: headers_of_logged_in_user
      end

      it 'returns an array with three questions sorted by date desc, then by title asc' do
        parsed_body = JSON.parse(response.body)
        question_ids = parsed_body.map { |q| q['id'] }

        expect(question_ids).to eq([question_starting_with_o.id, question_starting_with_w.id, question.id])
      end
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
      expect(parsed_body['user']).to eq('id' => question.user_id,
                                        'name' => user.name,
                                        'photo' => user.photo)
    end
  end

  describe 'POST /v1/questions' do
    let(:question_parameters) do
      {
        title: 'Nom de league?',
        description: 'Quel est le nom de la league?',
        endingDate: '2019-11-28T15:59:42.344Z',
        answers: [
          { title: 'WAM', description: 'WEB API MOBILE' },
          { title: 'FAME', description: 'FRONT API MOBILE EXPERIENCE' }
        ]
      }
    end

    save_current_user

    it 'returns a created HTTP status' do
      post '/api/v1/questions/', params: question_parameters, headers: headers_of_logged_in_user

      expect(response).to have_http_status :created
    end

    it 'returns the created question' do
      post '/api/v1/questions/', params: question_parameters, headers: headers_of_logged_in_user

      parsed_body = JSON.parse(response.body)
      expect(parsed_body.except('id', 'answers')).to eq('title' => 'Nom de league?',
                                                        'description' => 'Quel est le nom de la league?',
                                                        'endingDate' => '2019-11-28T15:59:42.344Z',
                                                        'user' => {
                                                          'id' => '208294780284604222681',
                                                          'name' => 'Test User',
                                                          'photo' => 'https://photos.fr/test-user.jpg'
                                                        })
    end

    it 'returns the created answers' do
      post '/api/v1/questions/', params: question_parameters, headers: headers_of_logged_in_user

      parsed_body = JSON.parse(response.body)
      expected_answers = parsed_body['answers'].map { |answer| answer.except('id') }
      expect(expected_answers).to eq([
                                       {
                                         'title' => 'WAM',
                                         'description' => 'WEB API MOBILE'
                                       },
                                       {
                                         'title' => 'FAME',
                                         'description' => 'FRONT API MOBILE EXPERIENCE'
                                       }
                                     ])
    end

    it 'sends an email' do
      expect do
        post '/api/v1/questions/', params: question_parameters, headers: headers_of_logged_in_user
      end.to change(ActionMailer::Base.deliveries, :count)
    end

    it 'returns an error when title field is missing' do
      post '/api/v1/questions/', params: question_parameters.except(:title), headers: headers_of_logged_in_user

      expect(response).to have_http_status :bad_request
    end

    it 'returns an error when description field is missing' do
      post '/api/v1/questions/', params: question_parameters.except(:description), headers: headers_of_logged_in_user

      expect(response).to have_http_status :bad_request
    end

    it 'returns an error when endingDate field is missing' do
      post '/api/v1/questions/', params: question_parameters.except(:endingDate), headers: headers_of_logged_in_user

      expect(response).to have_http_status :bad_request
    end

    it 'returns an error answers field is missing' do
      post '/api/v1/questions/', params: question_parameters.except(:answers), headers: headers_of_logged_in_user

      expect(response).to have_http_status :bad_request
    end

    it 'returns an error when title field is missing in an answer' do
      post '/api/v1/questions/', params: {
        title: 'Nom de league?',
        description: 'Quel est le nom de la league?',
        endingDate: '2019-11-28T15:59:42.344Z',
        answers: [
          { description: 'WEB API MOBILE' },
          { title: 'FAME', description: 'FRONT API MOBILE EXPERIENCE' }
        ]
      }, headers: headers_of_logged_in_user

      expect(response).to have_http_status :bad_request
    end

    it 'returns an error when description field is missing in an answer' do
      post '/api/v1/questions/', params: {
        title: 'Nom de league?',
        description: 'Quel est le nom de la league?',
        endingDate: '2019-11-28T15:59:42.344Z',
        answers: [
          { title: 'WAM' },
          { title: 'FAME', description: 'FRONT API MOBILE EXPERIENCE' }
        ]
      }, headers: headers_of_logged_in_user

      expect(response).to have_http_status :bad_request
    end
  end
end
