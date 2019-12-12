# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'an email' do
  it do
    expect(subject.to).not_to be_nil
    expect(subject.from).not_to be_nil
    expect(subject.body).not_to be_nil
    expect(subject.body).not_to match('<style')
    expect(subject.subject).not_to be_nil
  end
end
