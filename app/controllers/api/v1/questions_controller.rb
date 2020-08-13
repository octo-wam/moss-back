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
        NotificationMailer.with(question: @question).new_question.deliver_later

        render status: :created
      end

      def update
        @question = Question.find(params[:id])
        Question.transaction do
          @question.update(question_params)
          raise ActionController::BadRequest, 'Answers should be filled' if @question.answers.empty?
        end
      end

      def destroy
        @question = Question.find(params[:id]).destroy
      end

      private

      def question_params
        new_params = params.permit(:title, :description, :endingDate, answers: %i[id title description _destroy])
        new_params[:ending_date] = new_params.delete :endingDate if params[:endingDate]
        new_params[:answers_attributes] = new_params.delete :answers if params[:answers]
        new_params
      end
    end
  end
end
