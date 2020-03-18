# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < ApiController
      AUTHORIZED_SORT_FIELDS = %w(created_at title)
      DEFAULT_SORT_FIELD = 'created_at'
      AUTHORIZED_SORT_DIRECTIONS = %w(asc desc)

      def index
        @questions = Question.includes(:answers, :user)
        if params[:sort]
          # TODO: Move in a use case
          sort_segments = params[:sort].split(',')
          sort_segments.each do |sort_segment|
            next if sort_segment.blank?
            sort_field, sort_direction = sort_segment.split(':')
            sort_field ||= DEFAULT_SORT_FIELD
            next unless AUTHORIZED_SORT_FIELDS.include? sort_field
            sort_direction ||= 'asc'
            next unless AUTHORIZED_SORT_DIRECTIONS.include? sort_direction
            @questions = @questions.order(sort_field => sort_direction)
          end
        end
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
