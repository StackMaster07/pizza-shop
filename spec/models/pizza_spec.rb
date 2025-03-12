require 'rails_helper'

RSpec.describe Pizza, type: :model do
  let(:chef) { create(:user) }

  describe "Validations" do
    it "is valid with valid attributes" do
      pizza = build(:pizza, chef: chef)
      expect(pizza).to be_valid
    end

    it "is invalid without a name" do
      pizza = build(:pizza, name: nil, chef: chef)
      expect(pizza).not_to be_valid
      expect(pizza.errors[:name]).to include("can't be blank")
    end

    it "is invalid without a size" do
      pizza = build(:pizza, size: nil, chef: chef)
      expect(pizza).not_to be_valid
      expect(pizza.errors[:size]).to include("can't be blank")
    end

    it "is invalid without a description" do
      pizza = build(:pizza, description: nil, chef: chef)
      expect(pizza).not_to be_valid
      expect(pizza.errors[:description]).to include("can't be blank")
    end

    it "is invalid if the price is negative" do
      pizza = build(:pizza, price: -1, chef: chef)
      expect(pizza).not_to be_valid
      expect(pizza.errors[:price]).to include("must be greater than or equal to 0")
    end

    it "is valid if the price is zero" do
      pizza = build(:pizza, price: 0, chef: chef)
      expect(pizza).to be_valid
    end

    it "is invalid if the name is not unique" do
      create(:pizza, name: "Pepperoni", chef: chef)
      duplicate_pizza = build(:pizza, name: "Pepperoni", chef: chef)

      expect(duplicate_pizza).not_to be_valid
      expect(duplicate_pizza.errors[:name]).to include("has already been taken")
    end
  end

  describe "Associations" do
    it { is_expected.to belong_to(:chef).class_name('User') }
    it { is_expected.to have_many(:pizza_toppings).dependent(:destroy) }
    it { is_expected.to have_many(:toppings).through(:pizza_toppings) }
  end
end
