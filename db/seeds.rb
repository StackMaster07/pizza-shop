require 'faker'

puts 'Seeding data...'

User.destroy_all
Pizza.destroy_all
Topping.destroy_all

owner = User.create!(
  email: 'owner@example.com',
  password: 'password',
  password_confirmation: 'password',
  role: 'owner',
  user_name: 'Owner John'
)

chef = User.create!(
  email: 'chef@example.com',
  password: 'password',
  password_confirmation: 'password',
  role: 'chef',
  user_name: 'Chef Mike'
)

puts 'Created Users: Owner & Chef'

topping_data = [
  { name: 'Cheese', price_per_piece: 1.50, quantity: 100 },
  { name: 'Pepperoni', price_per_piece: 2.00, quantity: 100 },
  { name: 'Mushrooms', price_per_piece: 1.25, quantity: 100 },
  { name: 'Olives', price_per_piece: 1.00, quantity: 100 },
  { name: 'Onions', price_per_piece: 0.75, quantity: 100 },
  { name: 'Tomatoes', price_per_piece: 1.00, quantity: 100 },
  { name: 'Basil', price_per_piece: 0.50, quantity: 100 },
  { name: 'Garlic', price_per_piece: 0.75, quantity: 100 },
  { name: 'Chicken', price_per_piece: 2.50, quantity: 100 },
  { name: 'Beef', price_per_piece: 3.00, quantity: 100 }
]

pizza_data = [
  { name: 'Mexican', size: :medium },
  { name: 'Arabic', size: :large },
  { name: 'Taxmax', size: :large },
  { name: 'Ranch', size: :large },
  { name: 'Italian', size: :medium },
  { name: 'Margarita', size: :medium },
  { name: 'Lime', size: :small }
]

toppings = topping_data.map do |topping|
  Topping.create!(name: topping[:name], price_per_piece: topping[:price_per_piece], quantity: topping[:quantity])
end

puts "Created #{toppings.count} Toppings with Prices"

pizzas = pizza_data.map do |pizza_data|
  pizza = Pizza.create!(
    name: pizza_data[:name],
    description: Faker::Food.description,
    chef: chef,
    size: pizza_data[:size],
  )

  selected_toppings = toppings.sample(rand(2..5))

  selected_toppings.each do |topping|
    available_quantity = topping.quantity
    next if available_quantity <= 0
  
    quantity_used = rand(1..[available_quantity, 3].min)
    pizza.pizza_toppings.build(topping: topping, quantity: quantity_used)
    topping.update!(quantity: available_quantity - quantity_used)
  end

  pizza.save!

  puts "Created Pizza: #{pizza.name} with #{pizza.toppings.count} toppings"
end

puts "Seeding completed successfully!"
