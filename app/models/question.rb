# frozen_string_literal: true

class Question < ApplicationRecord
  include SortableConcern

  has_many :answers
  belongs_to :user
  accepts_nested_attributes_for :answers

  validates :title, :description, :ending_date, :user_id, presence: true

  scope :of_answer, ->(answer) { joins(:answers).where(answers: { id: answer }) }

  def ended?
    ending_date.before?(Time.zone.now)
  end

  def self.sort_regex
    /^(created_at|title)(:(asc|desc))?(,(created_at|title)(:(asc|desc))?)*$/
  end
end
