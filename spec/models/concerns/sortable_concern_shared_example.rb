# frozen_string_literal: true

require 'spec_helper'

shared_examples_for 'a model sortable by' do |parameter|
  context 'when sorting parameter is correct' do
    subject(:sorted_collection) { described_class.sorted_by(parameter) }

    it { expect { sorted_collection }.not_to raise_error }
  end
end

shared_examples_for 'a model not sortable by' do |parameter|
  context 'when sorting parameter is wrong' do
    subject(:sorted_collection) { described_class.sorted_by(parameter) }

    it { expect { sorted_collection }.to raise_error(ActiveRecord::StatementInvalid, 'Sort parameter is invalid') }
  end
end
