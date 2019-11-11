# frozen_string_literal: true

module Api
  module V1
    class VotesController < ApiController
      before_action :find_answer, only: %i[create update]

      def index
        @votes = Vote.all
      end

      def create
        @vote = Vote.create! answer: @answer, user_id: current_user['sub'], user_name: current_user['name']
        render status: :created
      end

      def update
        @vote = Vote.find_by(user_id: current_user['sub'], answer: Answer.where(question_id: @answer.question_id))
        @vote.update! answer_id: params[:answerId]
        render status: :ok
      end

      private

      def find_answer
        @answer = Answer.find(params[:answerId])
      end
    end
  end
end
