# frozen_string_literal: true

require 'rails_helper'
require 'mailers/shared_examples_for_an_email'

RSpec.describe NotificationMailer, type: :mailer do
  describe '#new_question' do
    subject(:mail) { described_class.with(question: question).new_question.deliver_now }

    let(:question) { create :question }

    before { ENV['TEAM_EMAIL_ADDRESS'] = 'team@email' }

    it_behaves_like 'an email'

    it do
      expect(mail.to).to eq ['team@email']
      expect(mail.subject).to eq '[WAM] Nous avons besoin de ton avis !'
    end
  end
end
