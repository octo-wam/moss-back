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
end
