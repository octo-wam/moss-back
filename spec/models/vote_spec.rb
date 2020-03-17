# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'associations' do
    subject(:vote) { build :vote }

    it { expect(vote).to belong_to :user }
    it { expect(vote).to belong_to :answer }
  end

  describe 'validations' do
    describe 'regular validations' do
      subject(:vote) { build :vote }

      it { is_expected.to validate_presence_of(:user_id) }
    end

    describe 'it is not possible to vote for an ended question' do
      let!(:answer) { create :answer, question: question }

      context 'question is ended' do
        let(:question) { create :question, ending_date: 1.hour.ago }

        let(:vote) { build :vote, answer: answer }

        it { expect(vote.valid?).to be false }
      end

      context 'question is not ended' do
        let(:question) { create :question, ending_date: 1.hour.from_now }

        let(:vote) { build :vote, answer: answer }

        it { expect(vote.valid?).to be true }
      end
    end

    describe 'a user cannot vote twice neither for the same answer nor for the same question' do
      let(:question) { create :question }
      let(:first_answer) { create :answer, question: question }

      save_current_user

      context 'current_user has already voted for this answer' do
        let!(:previous_vote) { create :vote, user_id: current_user['sub'], answer: first_answer }

        let(:new_vote) { build :vote, user_id: current_user['sub'], answer: first_answer }

        it { expect(new_vote.valid?).to be false }
      end

      context 'current_user has already voted for this question' do
        let(:second_answer) { create :answer, question: question }
        let!(:previous_vote) { create :vote, user_id: current_user['sub'], answer: first_answer }

        let(:new_vote) { build :vote, user_id: current_user['sub'], answer: second_answer }

        it { expect(new_vote.valid?).to be false }
      end

      context 'current_user has not already voted for this question' do
        let!(:previous_vote) { create :vote, user_id: current_user['sub'] }

        let(:new_vote) { build :vote, user_id: current_user['sub'], answer: first_answer }

        it { expect(new_vote.valid?).to be true }
      end
    end
  end

  describe '.on_question' do
    subject(:vote_on_question) { described_class.on_question(question) }

    let!(:question) { create :question }
    let!(:answer_of_question) { create :answer, question: question }
    let!(:vote_on_answer_of_question) { create :vote, answer: answer_of_question }
    let!(:vote_on_other_question) { create :vote }

    it 'only returns the vote related to the given question' do
      expect(vote_on_question).to eq([vote_on_answer_of_question])
    end
  end
end
