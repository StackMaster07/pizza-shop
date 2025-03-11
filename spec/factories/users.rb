FactoryBot.define do
  factory :user do
    user_name { Faker::Name.name }
    email { Faker::Internet.email }
    password { "password123" }

    trait :owner do
      role { "owner" }
    end

    trait :chef do
      role { "chef" }
    end    
  end
end
