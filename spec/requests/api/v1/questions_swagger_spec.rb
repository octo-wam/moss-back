# frozen_string_literal: true

require 'swagger_helper'

describe 'Questions Swagger', type: :request do
  answer_contract = {
    type: :object,
    properties: {
      id: { type: :string },
      title: { type: :string },
      description: { type: :string }
    },
    required: %w[title description]
  }
  question_contract = {
    type: :object,
    properties: {
      id: { type: :string },
      title: { type: :string },
      description: { type: :string },
      endingDate: { type: :string, format: :datetime },
      answers: {
        type: :array,
        items: answer_contract
      }
    },
    required: %w[id title description endingDate answers]
  }

  path '/api/v1/questions' do
    get 'Récupérer la liste des questions' do
      tags 'Questions'
      security [accessToken: []]
      produces 'application/json'

      response '200', 'Questions trouvées' do
        schema type: :array,
               items: question_contract

        let(:Authorization) { "Bearer #{access_token}" }
        before { create_list :question, 2 }

        run_test!
      end

      response '401', 'Non autorisé' do
        let(:Authorization) { '' }

        run_test!
      end
    end

    post 'Créer une question' do
      create_answer_contract = {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string }
        },
        required: %w[title description]
      }
      create_question_contract = {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string },
          endingDate: { type: :string, format: :datetime },
          answers: {
            type: :array,
            items: create_answer_contract
          }
        },
        required: %w[id title description endingDate answers]
      }

      tags 'Questions'
      security [accessToken: []]
      consumes 'application/json'
      parameter name: :question, in: :body, schema: create_question_contract

      response '201', 'Question créée' do
        let(:question) do
          question = create :question
          answer = create :answer
          {
            title: question.title,
            description: question.description,
            endingDate: question.ending_date,
            answers: [
              {
                title: answer.title,
                description: answer.description
              }
            ]
          }
        end
        let(:Authorization) { "Bearer #{access_token}" }

        run_test!
      end

      response '400', 'Mauvaise requête' do
        let(:question) { { title: 'foo' } }
        let(:Authorization) { "Bearer #{access_token}" }

        run_test!
      end

      response '401', 'Non autorisé' do
        let(:question) {}
        let(:Authorization) { '' }

        run_test!
      end
    end
  end

  path '/api/v1/questions/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'Identifiant de la question'

    get 'Récupérer une question' do
      tags 'Questions'
      security [accessToken: []]
      produces 'application/json'

      response '200', 'Question trouvée' do
        schema question_contract

        let!(:question) { create :question }
        let(:id) { question.id }
        let(:Authorization) { "Bearer #{access_token}" }

        run_test!
      end

      response '401', 'Non autorisé' do
        let(:id) {}
        let(:Authorization) { '' }

        run_test!
      end

      response '404', 'Question non trouvée' do
        let(:id) { 'invalid' }
        let(:Authorization) { "Bearer #{access_token}" }

        run_test!
      end
    end
  end
end
