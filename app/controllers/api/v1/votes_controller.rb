# frozen_string_literal: true

module Api
  module V1
    class VotesController < ApiController
      before_action :find_answer, only: %i[create update]

      def index
        @votes = Vote.on_question(params[:id]).includes(:user)
      end

      def create
        create_vote
      end

      def update
        if current_user_vote_for_this_question
          @vote.update! answer: @answer
        else
          create_vote
        end
      end

      private

      def find_answer
        @answer = Answer.find_by(id: params[:answerId])
        raise ActionController::BadRequest, 'answerId does not exist' unless @answer
      end

      def create_vote
        @vote = Vote.create!(user: current_user, answer: @answer)
        render status: :created
      end

      def current_user_vote_for_this_question
        question_answers = Answer.where(question_id: @answer.question_id)
        @vote = Vote.find_by(user: current_user, answer: question_answers)
      end
    end
  end
end
