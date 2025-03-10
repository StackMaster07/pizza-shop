class Pizza < ApplicationRecord
  belongs_to :chef, class_name: 'User'
  has_many :pizza_toppings, dependent: :destroy
  has_many :toppings, through: :pizza_toppings

  enum size: { small: 0, medium: 1, large: 2 }

  validates :name, presence: true, uniqueness: true
  validates :size, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :description, presence: true


  after_save :calculate_price

  private

  def calculate_price
    reload
    size_price = Constants::DEFAULT_PIZZA_PRICES[size]

    toppings_price = pizza_toppings.includes(:topping).sum do |pt|
      pt.topping.price_per_piece * pt.quantity
    end

    final_price = size_price + toppings_price
    
    update_column(:price, final_price)
  end
end
