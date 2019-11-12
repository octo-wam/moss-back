# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    association :answer
    user_id { Faker::Number.number(digits: 10) }
    user_name { Faker::Name.name }
  end
end
