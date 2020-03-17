# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    association :answer
    association :user
  end
end
