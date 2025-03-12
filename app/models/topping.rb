class Topping < ApplicationRecord
  has_many :pizza_toppings, dependent: :destroy
  has_many :pizzas, through: :pizza_toppings

  validates :name, presence: true, uniqueness: true
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
