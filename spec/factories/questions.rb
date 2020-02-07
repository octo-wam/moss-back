# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { Faker::Lorem.question }
    user_id { Faker::Number.number(digits: 10).to_s }
    user_name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    ending_date { 1.week.from_now }
  end
end
