module PizzaHelper
  def get_topping_quantity(pizza, topping)
    PizzaTopping.find_by(pizza: pizza, topping: topping).quantity || 0
  end

  def pizza_topping(pizza, topping)
    pizza.pizza_toppings.find { |pt| pt.topping_id == topping.id }
  end
end