# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers
  validates :title, :description, :ending_date, :answers, presence: true
end
