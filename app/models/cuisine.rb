class Cuisine < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true
  validates :restaurant_id, presence: true
  validates :cook_time, presence: true
  # mount_uploader :image, ImageUploader
  has_many :carts, through: :carts_cuisines
  has_many :carts_cuisines
  belongs_to :restaurant
  has_many :orders, through: :orders_cuisines
  has_many :orders_cuisines
end
