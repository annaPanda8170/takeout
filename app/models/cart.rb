class Cart < ApplicationRecord
  validates :restaurant_id, presence: true
  has_many :cuisines, through: :carts_cuisines
  has_many :carts_cuisines
  accepts_nested_attributes_for :carts_cuisines
end
