require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'associations' do
    subject(:vote) { build :vote }

    it { expect(vote).to belong_to :answer }
  end

  describe 'validations' do
    describe 'a user cannot vote twice neither for the same answer nor for the same question' do
      let(:question) { create :question }
      let(:first_answer) { create :answer, question: question }

      context 'current_user has already voted for this answer' do
        let!(:previous_vote) { create :vote, user_id: current_user['id'], answer: first_answer }

        let(:new_vote) { build :vote, user_id: current_user['id'], answer: first_answer }

        it { expect(new_vote.valid?).to be false }
      end

      context 'current_user has already voted for this question' do
        let(:second_answer) { create :answer, question: question }
        let!(:previous_vote) { create :vote, user_id: current_user['id'], answer: first_answer }

        let(:new_vote) { build :vote, user_id: current_user['id'], answer: second_answer }

        it { expect(new_vote.valid?).to be false }
      end

      context 'current_user has not already voted for this question' do
        let!(:previous_vote) { create :vote, user_id: current_user['id'] }

        let(:new_vote) { build :vote, user_id: current_user['id'], answer: first_answer }

        it { expect(new_vote.valid?).to be true }
      end
    end
  end
end
