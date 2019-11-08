require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    subject(:answer) { build :answer }

    it { expect(answer).to belong_to :question }
  end
end
