FactoryBot.define do
  factory :answer do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    association :question
  end
end
