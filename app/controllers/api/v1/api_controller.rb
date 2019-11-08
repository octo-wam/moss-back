# frozen_string_literal: true

module Api
  module V1
    class ApiController < ApplicationController
      rescue_from ActiveRecord::RecordInvalid, with: :bad_request
      rescue_from ActiveRecord::ReadOnlyRecord, with: :bad_request
      rescue_from ActionController::BadRequest, with: :bad_request

      def bad_request(error)
        render body: { error: error.message }.to_json, status: :bad_request
      end
    end
  end
end
