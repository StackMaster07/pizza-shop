require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Validations" do
    let(:user) { build(:user) }

    it "is valid with valid attributes" do
      expect(user).to be_valid
    end

    it "is invalid without an email" do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "is invalid if the email is not unique" do
      create(:user, email: "someone@test.com")
      duplicate_user = build(:user, email: "someone@test.com")

      expect(duplicate_user).not_to be_valid
      expect(duplicate_user.errors[:email]).to include("has already been taken")
    end

    it "is invalid without a user name" do
      user = build(:user, user_name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:user_name]).to include("can't be blank")
    end

    it "is invalid without a role" do
      user = build(:user, role: nil)
      expect(user).not_to be_valid
      expect(user.errors[:role]).to include("can't be blank")
    end

    it "allows 'owner' as a valid role" do
      user = build(:user, role: :owner)
      expect(user).to be_valid
    end
  
    it "allows 'chef' as a valid role" do
      user = build(:user, role: :chef)
      expect(user).to be_valid
    end
  
    it "does not allow invalid roles" do
      expect { build(:user, role: :invalid_role) }.to raise_error(ArgumentError)
    end
    
  end

  describe "Associations" do
    it { is_expected.to have_many(:pizzas).with_foreign_key('chef_id').dependent(:destroy) }
  end

  describe "Enums" do
    it "defines roles correctly" do
      expect(User.roles).to eq({ "owner" => 1, "chef" => 2 })
    end

    it "allows setting and checking roles" do
      owner = create(:user, role: :owner)
      chef = create(:user, :chef)

      expect(owner.owner?).to be true
      expect(owner.chef?).to be false

      expect(chef.chef?).to be true
      expect(chef.owner?).to be false
    end
  end

  describe "Devise Modules" do
    let(:user) { create(:user) }

    it "authenticates with correct password" do
      expect(user.valid_password?("password123")).to be true
    end

    it "does not authenticate with incorrect password" do
      expect(user.valid_password?("wrongpassword")).to be false
    end

    it "remembers the user when remember_me is set" do
      expect(user.remember_me).to be_nil
      user.remember_me = true
      expect(user.remember_me).to be true
    end
  end
end
