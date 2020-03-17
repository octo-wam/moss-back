# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:id, &:to_s)
    name { Faker::Name.name }
    sequence(:photo) { |n| "https://photos.fr/#{n}.jpg" }
  end
end
