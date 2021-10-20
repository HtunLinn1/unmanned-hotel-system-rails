class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :credit_no, presence: true, length: {minimum: 15, maximum: 15}
end
