FactoryBot.define do
  factory :vote do
    association :answer
    user_id { "user_id" }
    user_name { "user_name" }
  end
end
