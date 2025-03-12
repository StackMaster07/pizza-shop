FactoryBot.define do
  factory :topping do
    sequence(:name) { |n| "Topping #{n}" }
    quantity { rand(5..50) }
    price_per_piece { rand(0.5..5.0) }
  end
end
