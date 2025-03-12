FactoryBot.define do
  factory :pizza do
    sequence(:name) { |n| "Pizza #{n}" }
    description { Faker::Food.description }
    price { 9.99 }
    size { Pizza.sizes.keys.sample }
    association :chef, factory: :user

    after(:create) do |pizza|
      create_list(:pizza_topping, 2, pizza: pizza)
    end
  end
end