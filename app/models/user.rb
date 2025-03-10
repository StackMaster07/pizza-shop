class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :pizzas, foreign_key: 'chef_id', dependent: :destroy

  enum role: { owner: 1, chef: 2 }

  validates :role, presence: true, inclusion: { in: roles.keys }
  validates :email, presence: true, uniqueness: true
  validates :user_name, presence: true
end
