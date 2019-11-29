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
        answers = []
        params[:answers]&.each do |answer|
          next if answer.blank?
          answers << Answer.new(title: answer[:title], description: answer[:description])
        end

        raise ActionController::BadRequest.new 'Answers should be filled' if answers.empty?

        @question = Question.create!(title: params[:title],
                                    description: params[:description],
                                    ending_date: params[:endingDate],
                                    answers: answers)

        render status: :created
      end
    end
  end
end
