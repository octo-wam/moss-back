# frozen_string_literal: true

module Api
  module V1
    class VotesController < ApiController
      before_action :find_answer, only: %i[create update]

      def index
        @votes = Vote.on_question(params[:id])
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
        @answer = Answer.find(params[:answerId])
      end

      def create_vote
        @vote = Vote.create!(
          answer: @answer,
          user_id: current_user['sub'],
          user_name: current_user['name']
        )
        render status: :created
      end

      def current_user_vote_for_this_question
        question_answers = Answer.where(question_id: @answer.question_id)
        @vote = Vote.find_by(answer: question_answers, user_id: current_user['sub'])
      end
    end
  end
end
