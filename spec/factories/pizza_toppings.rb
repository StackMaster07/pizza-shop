FactoryBot.define do
  factory :pizza_topping do
    association :pizza
    association :topping
    quantity { rand(1..3) }
  end
end
