# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    subject(:question) { build :question }

    it { expect(question).to have_many :answers }
    it { expect(question).to accept_nested_attributes_for(:answers) }
  end

  describe 'validations' do
    subject(:question) { build :question }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:ending_date) }
  end

  describe '.of_answer' do
    subject(:question_of_answer) { described_class.of_answer(answer) }

    let(:question) { create :question }
    let!(:answer) { create :answer, question: question }
    let!(:other_answer) { create :answer }

    it 'only returns the question related to the given answer' do
      expect(question_of_answer).to eq([question])
    end
  end
end
