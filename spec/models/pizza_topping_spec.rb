require 'rails_helper'

RSpec.describe PizzaTopping, type: :model do
  let(:pizza_topping) { build(:pizza_topping) }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(pizza_topping).to be_valid
    end

    it "is invalid without a pizza" do
      pizza_topping = build(:pizza_topping, pizza: nil)
      expect(pizza_topping).not_to be_valid
      expect(pizza_topping.errors[:pizza]).to include("must exist")
    end

    it "is invalid without a topping" do
      pizza_topping = build(:pizza_topping, topping: nil)
      expect(pizza_topping).not_to be_valid
      expect(pizza_topping.errors[:topping]).to include("must exist")
    end

    it "does not allow duplicate toppings on the same pizza" do
      create(:pizza_topping, pizza: pizza_topping.pizza, topping: pizza_topping.topping)
      duplicate_pizza_topping = build(:pizza_topping, pizza: pizza_topping.pizza, topping: pizza_topping.topping)

      expect(duplicate_pizza_topping).not_to be_valid
      expect(duplicate_pizza_topping.errors[:pizza_id]).to include("Topping already added to this pizza")
    end

    it "is invalid if quantity is not an integer" do
      pizza_topping = build(:pizza_topping, quantity: 2.5)
      expect(pizza_topping).not_to be_valid
      expect(pizza_topping.errors[:quantity]).to include("must be an integer")
    end

    it "is invalid if quantity is zero" do
      pizza_topping = build(:pizza_topping, quantity: 0)
      expect(pizza_topping).not_to be_valid
      expect(pizza_topping.errors[:quantity]).to include("must be greater than 0")
    end

    it "is invalid if quantity is negative" do
      pizza_topping = build(:pizza_topping, quantity: -1)
      expect(pizza_topping).not_to be_valid
      expect(pizza_topping.errors[:quantity]).to include("must be greater than 0")
    end
  end

  describe "Associations" do
    it { should belong_to(:pizza) }
    it { should belong_to(:topping) }
  end
end
