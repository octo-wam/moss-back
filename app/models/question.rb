# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers
  accepts_nested_attributes_for :answers

  validates :title, :description, :ending_date, presence: true

  scope :of_answer, ->(answer) { joins(:answers).where(answers: { id: answer }) }
end
