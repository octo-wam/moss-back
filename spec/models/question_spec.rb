# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    subject(:question) { build :question }

    it { expect(question).to have_many :answers }
    it { expect(question).to belong_to :user }
    it { expect(question).to accept_nested_attributes_for(:answers) }
  end

  describe 'validations' do
    subject(:question) { build :question }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:ending_date) }
    it { is_expected.to validate_presence_of(:user_id) }
  end

  describe '.of_answer' do
    subject(:question_of_answer) { described_class.of_answer(answer) }

    let(:related_question) { create :question }
    let(:answer) { create :answer, question: related_question }

    before do
      unrelated_question = create :question
      create :answer, question: unrelated_question
    end

    it 'only returns the question related to the given answer' do
      expect(question_of_answer).to eq([related_question])
    end
  end

  describe '.ended?' do
    subject(:ended_question?) { question.ended? }

    let(:date_of_function_call) { DateTime.new(2020, 8, 1, 12) }

    before { Timecop.freeze(date_of_function_call) }

    after { Timecop.return }

    context 'question has an ending date in the past' do
      let(:question) { create :question, ending_date: DateTime.new(2020, 8, 1, 10) }

      it('is ended') { expect(ended_question?).to eq true }
    end

    context 'question has an ending date in the future' do
      let(:question) { create :question, ending_date: DateTime.new(2020, 8, 2, 12) }

      it('is not ended') { expect(ended_question?).to eq false }
    end
  end
end
