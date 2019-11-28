# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < ApiController
      def index
        @questions = Question.includes(:answers)
      end

      def show
        @question = Question.find(params[:id])
      end

      def create
        render status: :created
      end
    end
  end
end
