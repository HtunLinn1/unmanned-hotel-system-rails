class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :phone, presence: true, length: {minimum: 11, maximum: 11}

  has_many :bookings, dependent: :destroy
  has_many :inquiries, dependent: :destroy
end
