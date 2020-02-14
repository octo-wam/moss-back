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
        @question = Question.new(question_params)
        raise ActionController::BadRequest, 'Answers should be filled' if @question.answers.empty?
        @question.save!
        NotificationMailer.with(question: @question).new_question(recipient_param).deliver_later
        render status: :created
      end

      private

      def question_params
        new_params = params[:question].permit(:title, :description, :endingDate, answers: %i[id title description])
        new_params[:ending_date] = new_params.delete :endingDate if params[:question][:endingDate]
        new_params[:answers_attributes] = new_params.delete :answers if params[:question][:answers]
        new_params
      end

      def recipient_param
        new_param = params[:recipients]
        new_param
      end
    end
  end
end
