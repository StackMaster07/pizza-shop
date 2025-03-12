require 'rails_helper'

RSpec.describe PizzaPolicy, type: :policy do
  let(:owner) { create(:user, :owner) }
  let(:chef) { create(:user, :chef) }
  let(:pizza) { create(:pizza, chef: chef) } 

  subject { described_class }

  describe "Scope" do
    let(:scope) { Pizza.all }

    context "when user is an owner" do
      it "returns all pizzas" do
        another_pizza = create(:pizza)
        resolved_scope = subject::Scope.new(owner, scope).resolve
        expect(resolved_scope).to contain_exactly(pizza, another_pizza)
      end
    end

    context "when user is a chef" do
      it "returns only the pizzas belonging to that chef" do
        another_chef = create(:user, :chef)
        another_pizza = create(:pizza, chef: another_chef)

        resolved_scope = subject::Scope.new(chef, scope).resolve
        expect(resolved_scope).to match_array([pizza])
      end
    end
  end

  describe "#index?" do
    it "allows all users to access the index page" do
      expect(subject.new(owner, Pizza).index?).to be true
      expect(subject.new(chef, Pizza).index?).to be true
    end
  end

  describe "#show?" do
    it "allows only chefs to view pizzas" do
      expect(subject.new(chef, pizza).show?).to be true
      expect(subject.new(owner, pizza).show?).to be false
    end
  end

  describe "#create?" do
    it "allows only chefs to create pizzas" do
      expect(subject.new(chef, pizza).create?).to be true
      expect(subject.new(owner, pizza).create?).to be false
    end
  end

  describe "#update?" do
    it "allows only chefs to update pizzas" do
      expect(subject.new(chef, pizza).update?).to be true
      expect(subject.new(owner, pizza).update?).to be false
    end
  end

  describe "#destroy?" do
    it "allows only chefs to delete pizzas" do
      expect(subject.new(chef, pizza).destroy?).to be true
      expect(subject.new(owner, pizza).destroy?).to be false
    end
  end
end
