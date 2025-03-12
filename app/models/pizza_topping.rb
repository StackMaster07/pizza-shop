class PizzaTopping < ApplicationRecord
  belongs_to :pizza
  belongs_to :topping

  validates :pizza_id, uniqueness: { scope: :topping_id, message: 'Topping already added to this pizza' }
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
end
