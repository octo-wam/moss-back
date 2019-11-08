# frozen_string_literal: true

module Api
  module V1
    class ApiController < ApplicationController
      attr_reader :current_user
      before_action :authenticate

      rescue_from ActiveRecord::RecordInvalid, with: :bad_request
      rescue_from ActiveRecord::ReadOnlyRecord, with: :bad_request
      rescue_from ActionController::BadRequest, with: :bad_request

      def bad_request(error)
        render body: { error: error.message }.to_json, status: :bad_request
      end

      def authenticate
        bearer = request.headers['Authorization']
        raise Unauthorized, "header `Authorization` missing" unless bearer

        token = bearer.match(/Bearer (.+)/)[1]
        @current_user = JWT.decode(token, ENV['SECRET_KEY_BASE'], true, { algorithm: 'HS256' }).first
      rescue Exception => e
        render status: :unauthorized, json: {
          error: 'UNAUTHORIZED',
          message: e.message
        }
      end
      class Unauthorized < StandardError; end
    end
  end
end
