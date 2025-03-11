require 'rails_helper'

RSpec.describe ToppingPolicy, type: :policy do
  let(:owner) { create(:user, :owner) }
  let(:chef) { create(:user, :chef) }
  let(:topping) { create(:topping) } 

  subject { described_class }

  describe "Scope" do
    let(:scope) { Topping.all }

    context "when user is an owner" do
      it "returns all toppings" do
        another_topping = create(:topping)
        resolved_scope = subject::Scope.new(owner, scope).resolve
        expect(resolved_scope).to contain_exactly(topping, another_topping)
      end
    end

    context "when user is a chef" do
      it "returns no toppings" do
        resolved_scope = subject::Scope.new(chef, scope).resolve
        expect(resolved_scope).to be_empty
      end
    end
  end

  describe "#index?" do
    it "allows only owners to view the toppings index" do
      expect(subject.new(owner, Topping).index?).to be true
      expect(subject.new(chef, Topping).index?).to be false
    end
  end

  describe "#show?" do
    it "allows only owners to view toppings" do
      expect(subject.new(owner, topping).show?).to be true
      expect(subject.new(chef, topping).show?).to be false
    end
  end

  describe "#create?" do
    it "allows only owners to create toppings" do
      expect(subject.new(owner, topping).create?).to be true
      expect(subject.new(chef, topping).create?).to be false
    end
  end

  describe "#update?" do
    it "allows only owners to update toppings" do
      expect(subject.new(owner, topping).update?).to be true
      expect(subject.new(chef, topping).update?).to be false
    end
  end

  describe "#destroy?" do
    it "allows only owners to delete toppings" do
      expect(subject.new(owner, topping).destroy?).to be true
      expect(subject.new(chef, topping).destroy?).to be false
    end
  end
end
