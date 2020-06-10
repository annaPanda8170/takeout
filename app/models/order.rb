class Order < ApplicationRecord
  validates :time, null: false
  has_many :cuisines, through: :carts_cuisines
  has_many :orders_cuisines
  accepts_nested_attributes_for :orders_cuisines
end
