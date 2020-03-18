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

    it 'returns a created HTTP status' do
      post '/api/v1/questions/', params: question_parameters, headers: headers_of_logged_in_user

      expect(response).to have_http_status :created
    end

    it 'returns the created question' do
      post '/api/v1/questions/', params: question_parameters, headers: headers_of_logged_in_user

      parsed_body = JSON.parse(response.body)
      expect(parsed_body.except('id', 'answers')).to eq('title' => 'Nom de league?',
                                                        'description' => 'Quel est le nom de la league?',
                                                        'endingDate' => '2019-11-28T15:59:42.344Z')
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

  # TODO: Block to the question user/owner
  describe 'PUT /v1/questions/:id' do
    subject(:update_question) do
      put "/api/v1/questions/#{question.id}", params: question_new_parameters, headers: headers_of_logged_in_user
    end

    context 'parameters are good' do
      let!(:answer_to_update) { create :answer, title: 'Answer to update', question: question }
      let!(:answer_to_ignore) { create :answer, title: 'Answer to ignore', question: question }
      let!(:answer_to_delete) { create :answer, title: 'Answer to delete', question: question }

      let(:question_new_parameters) do
        {
          title: 'Nom de league?',
          description: 'Quel est le nom de la league?',
          endingDate: '2019-11-28T15:59:42.344Z',
          answers: [
            { id: answer_to_update.id, title: 'Updated answer', description: 'New Description' },
            { id: answer_to_delete.id, title: 'Delete this', _destroy: 'true' },
            { title: 'New answer', description: 'FRONT API MOBILE EXPERIENCE' }
          ]
        }
      end

      it 'returns a ok HTTP status' do
        update_question

        expect(response).to have_http_status :ok
      end

      it 'returns the updated question' do
        update_question

        parsed_body = JSON.parse(response.body)
        expect(parsed_body.except('id', 'answers')).to eq('title' => 'Nom de league?',
                                                          'description' => 'Quel est le nom de la league?',
                                                          'endingDate' => '2019-11-28T15:59:42.344Z')
      end

      it 'adds one answer but removes one answer' do
        expect { update_question }.not_to change(Answer, :count)
      end

      it 'returns the updated answers (one created, one updated, one deleted)' do
        update_question

        parsed_body = JSON.parse(response.body)
        expected_answers = parsed_body['answers'].map { |answer| answer.except('id', 'description') }
        expect(expected_answers).to eq([
                                         { 'title' => 'Updated answer' },
                                         { 'title' => 'Answer to ignore' },
                                         { 'title' => 'New answer' }
                                       ])
      end
    end

    context 'no answer is given' do
      let!(:answer) { create :answer, question: question }

      let(:question_new_parameters) do
        {
          title: 'Nom de league?',
          answers: []
        }
      end

      it 'returns an ok HTTP status' do
        update_question

        expect(response).to have_http_status :ok
      end
    end

    context 'asking to delete the last answer' do
      let!(:answer) { create :answer, title: 'Last answer', question: question }

      let(:question_new_parameters) do
        {
          title: 'Nom de league?',
          answers: [
            { id: answer.id, title: 'Do not delete this', _destroy: 'true' }
          ]
        }
      end

      it 'does not delete the answer' do
        expect { update_question }.not_to change(Answer, :count)
      end

      it 'does not delete the answer 2' do
        update_question

        expect(answer.reload.title).to eq 'Last answer'
      end

      it 'returns a bad request HTTP status' do
        update_question

        expect(response).to have_http_status :bad_request
      end
    end
  end

  # TODO: Block to the question user/owner
  describe 'DELETE /v1/questions/:id' do
    subject(:delete_question) { delete "/api/v1/questions/#{question.id}", headers: headers_of_logged_in_user }

    let!(:question) { create :question }

    before do
      create :answer, question: question
      create :answer, question: question
    end

    it 'deletes the question' do
      expect { delete_question }.to change(Question, :count).by(-1)
    end

    xit 'deletes two answers' do
      expect { delete_question }.to change(Answer, :count).by(-2)
    end

    it 'returns a no_content HTTP status' do
      delete_question

      expect(response).to have_http_status :no_content
    end
  end
end
