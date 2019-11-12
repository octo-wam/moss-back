# frozen_string_literal: true

class VoteValidator < ActiveModel::Validator
  def validate(vote)
    if vote.already_exists_for_the_same_answer?
      vote.errors[:user_id] << 'should vote for an answer once'
    elsif vote.already_exists_for_the_same_question?
      vote.errors[:user_id] << 'should vote for a question once'
    end
  end
end

class Vote < ApplicationRecord
  belongs_to :answer

  validates_with VoteValidator

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
