# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    subject(:question) { build :question }

    it { expect(question).to have_many :answers }
  end
end
