require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'associations' do
    subject(:vote) { build :vote }

    it { expect(vote).to belong_to :answer }
  end
end
