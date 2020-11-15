# frozen_string_literal: true

# Model that use this concern must implement a "sort_regex" class method

module SortableConcern
  extend ActiveSupport::Concern

  included do
    scope :sorted_by, (->(sort_parameter) { order(sort_collection_by(sort_parameter)) })
  end

  class_methods do
    def sort_collection_by(sort_parameter)
      return if sort_parameter.blank?

      raise ActiveRecord::StatementInvalid, 'Sort parameter is invalid' unless sort_parameter_valid?(sort_parameter)

      sort_segments = sort_parameter.split(',')
      order_predicates_from_segments(sort_segments)
    end

    private

    def order_predicates_from_segments(sort_segments)
      sort_segments.collect do |sort_segment|
        sort_field, sort_direction = sort_segment.split(':')
        sort_direction ||= 'asc'

        if date_field?(sort_field)
          { sort_field => sort_direction }
        else
          Arel.sql("LOWER(#{sort_field}) #{sort_direction.upcase}")
        end
      end
    end

    def date_field?(sort_field)
      sort_field.end_with? '_at'
    end

    def sort_parameter_valid?(sort_parameter)
      sort_regex.match? sort_parameter
    end
  end
end