# frozen_string_literal: true

require 'swagger_helper'

describe 'Users Swagger', type: :request do
  user_contract = {
    type: :object,
    properties: {
      id: { type: :string },
      name: { type: :string },
      email: { type: :string }
    },
    required: %w[id name email]
  }

  path '/api/v1/me' do
    get 'Récupérer des informations sur l\'utilisateur courant' do
      tags 'Users'
      security [accessToken: %w[email profile]]
      produces 'application/json'

      response '200', 'Utilisateur trouvé' do
        schema user_contract

        let(:Authorization) { "Bearer #{access_token}" }
        run_test!
      end

      response '401', 'Non autorisé' do
        let(:Authorization) { '' }

        run_test!
      end
    end
  end
end
