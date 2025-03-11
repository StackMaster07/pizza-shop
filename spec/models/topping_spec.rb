require 'rails_helper'

RSpec.describe Topping, type: :model do
  describe "Validations" do
    let(:topping) { build(:topping) }

    it "is valid with valid attributes" do
      expect(topping).to be_valid
    end

    it "is invalid without a name" do
      topping = build(:topping, name: nil)
      expect(topping).not_to be_valid
      expect(topping.errors[:name]).to include("can't be blank")
    end

    it "is invalid if the name is not unique" do
      create(:topping, name: "Cheese")
      duplicate_topping = build(:topping, name: "Cheese")

      expect(duplicate_topping).not_to be_valid
      expect(duplicate_topping.errors[:name]).to include("has already been taken")
    end

    it "is invalid if quantity is not an integer" do
      topping = build(:topping, quantity: 2.5)
      expect(topping).not_to be_valid
      expect(topping.errors[:quantity]).to include("must be an integer")
    end

    it "is invalid if quantity is negative" do
      topping = build(:topping, quantity: -1)
      expect(topping).not_to be_valid
      expect(topping.errors[:quantity]).to include("must be greater than or equal to 0")
    end
  end

  describe "Associations" do
    it { should have_many(:pizza_toppings).dependent(:destroy) }
    it { should have_many(:pizzas).through(:pizza_toppings) }
  end
end
