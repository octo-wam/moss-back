# frozen_string_literal: true

module Api
  module V1
    class ApiController < ApplicationController
      attr_reader :current_user
      before_action :authenticate

      rescue_from ActiveRecord::RecordInvalid, with: :bad_request
      rescue_from ActiveRecord::ReadOnlyRecord, with: :bad_request
      rescue_from ActionController::BadRequest, with: :bad_request

      def authenticate
        bearer = request.headers['Authorization']
        raise Unauthorized, '`Authorization` header is missing.' unless bearer

        token = bearer.match(/Bearer (.+)/)[1]
        @current_user = JWT.decode(token, ENV['SECRET_KEY_BASE'], true, algorithm: 'HS256').first
      rescue StandardError => e
        render status: :unauthorized, json: {
          error: 'UNAUTHORIZED',
          message: e.message
        }
      end
      class Unauthorized < StandardError; end

      private

      def current_user_id
        {
          user_id: current_user['sub']
        }
      end

      def bad_request(error)
        render json: { error: error.message }, status: :bad_request
      end
    end
  end
end
