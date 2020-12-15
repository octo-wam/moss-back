# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApiController
      def me
        @current_user = current_user
      end
    end
  end
end
