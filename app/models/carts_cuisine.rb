class CartsCuisine < ApplicationRecord
  validates :cart, presence: true
  validates :cuisine, presence: true
  belongs_to :cart
  belongs_to :cuisine
end
