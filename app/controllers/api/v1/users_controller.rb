# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApiController
      def index
        @current_user = current_user
      end
    end
  end
end
