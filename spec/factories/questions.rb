# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { Faker::Lorem.question }
    description { Faker::Lorem.paragraph }
    ending_date { 1.week.from_now }
  end
end
