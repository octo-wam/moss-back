# frozen_string_literal: true

require 'swagger_helper'

describe 'Votes Swagger', type: :request do
  path '/api/v1/questions/{id}/votes' do
    parameter name: 'id', in: :path, type: :string, description: 'Identifiant de la question'

    let(:question) { create :question }
    let(:id) { question.id }
    let(:answer) { create :answer, question: question }

    get 'Récupérer la liste des votes pour une question' do
      tags 'Votes'
      security [accessToken: []]
      produces 'application/json'

      user_contract = {
        type: :object,
        properties: {
          id: { type: :string },
          name: { type: :string }
        },
        required: %w[id name]
      }
      votes_contract = {
        type: :object,
        properties: {
          id: { type: :string, format: :uuid },
          answerId: { type: :string, format: :uuid },
          user: user_contract
        },
        required: %w[id answerId user]
      }

      response '200', 'Votes trouvés' do
        schema type: :array,
               items: votes_contract

        before { create_list :vote, 2 }

        let(:Authorization) { "Bearer #{access_token}" }
        run_test!
      end

      response '401', 'Non autorisé' do
        let(:Authorization) { '' }

        run_test!
      end
    end

    create_votes_contract = {
      type: :object,
      properties: {
        answerId: { type: :string, format: :uuid }
      },
      required: %w[id answerId]
    }

    post 'Créer un vote' do
      tags 'Votes'
      security [accessToken: []]
      consumes 'application/json'
      parameter name: :vote, in: :body, schema: create_votes_contract

      response '201', 'Vote créé' do
        let(:vote) { { answerId: answer.id } }

        let(:Authorization) { "Bearer #{access_token}" }
        run_test!
      end

      response '400', 'Mauvaise requête' do
        let(:vote) { {} }

        let(:Authorization) { "Bearer #{access_token}" }
        run_test!
      end

      response '401', 'Non autorisé' do
        let(:vote) { {} }
        let(:Authorization) { '' }

        run_test!
      end

      response '404', 'Non trouvé' do
        let(:id) {}
        let(:vote) { { answerId: answer.id } }

        let(:Authorization) { "Bearer #{access_token}" }
        run_test!
      end
    end

    put 'Mettre à jour un vote' do
      tags 'Votes'
      security [accessToken: []]
      consumes 'application/json'
      parameter name: :vote, in: :body, schema: create_votes_contract

      before { create :vote, answer: answer, user_id: current_user_id }

      response '200', 'Vote mis à jour' do
        let(:vote) { { answerId: answer.id } }

        let(:Authorization) { "Bearer #{access_token}" }
        run_test!
      end

      response '400', 'Mauvaise requête' do
        let(:vote) { { id: 'foo' } }

        let(:Authorization) { "Bearer #{access_token}" }
        run_test!
      end

      response '401', 'Non autorisé' do
        let(:vote) {}
        let(:Authorization) { '' }

        run_test!
      end

      response '404', 'Non trouvé' do
        let(:id) {}
        let(:vote) { { answerId: answer.id } }

        let(:Authorization) { "Bearer #{access_token}" }
        run_test!
      end
    end
  end
end
