# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < ApiController
      def index
        @questions = Question.includes(:answers)
        render content_type: "application/json", status: :ok
      end
    end
  end
end
