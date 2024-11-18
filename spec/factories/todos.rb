FactoryBot.define do
  factory :todo do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    status { "pending" }
    priority { "low" }
    due_date { Faker::Date.forward(days: 23) }
    user { create(:user) }
  end
end
