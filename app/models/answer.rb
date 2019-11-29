# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question

  validates :title, :description, presence: true
end
