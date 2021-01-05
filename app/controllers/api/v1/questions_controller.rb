# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < ApiController
      def index
        @questions = Question.includes(:answers, :user)
      end

      def show
        @question = Question.find(params[:id])
      end

      def create
        create_question
        NotificationMailer.with(question: @question).new_question.deliver_later
        render status: :created
      end

      private

      def create_question
        @question = Question.new(question_params)
        raise ActionController::BadRequest, 'Answers should be filled' if @question.answers.empty?

        @question.user = current_user
        @question.save!
      end

      def question_params
        new_params = params.permit(:title, :description, :endingDate, answers: %i[title description])
        new_params[:ending_date] = new_params.delete :endingDate if params[:endingDate]
        new_params[:answers_attributes] = new_params.delete :answers if params[:answers]
        new_params
      end
    end
  end
end
