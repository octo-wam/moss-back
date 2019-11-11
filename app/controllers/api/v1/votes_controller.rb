# frozen_string_literal: true

module Api
  module V1
    class VotesController < ApiController
      def index
        @votes = Vote.all
      end

      def create
        answer = Answer.find(params[:answerId])
        vote = Vote.create! answer: answer, user_id: current_user['sub'], user_name: current_user['username'] 
        render json: {'id' => vote.id}, location: vote.id, status: :created
      end
    end
  end
end
