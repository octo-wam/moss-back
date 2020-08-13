# frozen_string_literal: true

class Question < ApplicationRecord
  acts_as_paranoid

  has_many :answers
  accepts_nested_attributes_for :answers, allow_destroy: true

  validates :title, :description, :ending_date, presence: true
end
