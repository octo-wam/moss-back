# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    subject(:answer) { build :answer }

    it { expect(answer).to belong_to :question }
  end

  describe 'validations' do
    subject(:answer) { build :answer }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
  end
end
