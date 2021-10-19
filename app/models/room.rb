class Room < ApplicationRecord
  validates :room_type, presence: true
  validates :room_no, presence: true, uniqueness: true
  validates :price, presence: true
  validates :limit_person, presence: true
  validates :image, presence: true
  mount_uploader :image, ImageUploader

  has_many :bookings, dependent: :destroy
end
