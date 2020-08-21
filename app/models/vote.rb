# frozen_string_literal: true

class VoteValidator < ActiveModel::Validator
  def validate(vote)
    vote.errors[:question] << 'is ended' if vote.on_ended_question?

    if vote.already_exists_for_the_same_answer?
      vote.errors[:user] << 'should vote for an answer once'
    elsif vote.already_exists_for_the_same_question?
      vote.errors[:user] << 'should vote for a question once'
    end
  end
end

class Vote < ApplicationRecord
  belongs_to :answer

  validates_with VoteValidator

  scope :on_question, ->(question) { joins(answer: :question).where(answers: { question: question }) }

  def on_ended_question?
    question_of_answer = Question.of_answer(answer_id).first
    question_of_answer&.ended?
  end

  def other_votes
    Vote.where.not(id: id)
  end

  def already_exists_for_the_same_answer?
    other_votes.exists?(user_id: user_id, answer_id: answer_id)
  end

  def already_exists_for_the_same_question?
    other_votes.exists?(user_id: user_id, answer: Answer.where(question_id: answer&.question_id))
  end
end
