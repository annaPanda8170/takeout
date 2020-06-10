class OrdersCuisine < ApplicationRecord
  validates :order, presence: true
  validates :cuisine, presence: true
  belongs_to :order
  belongs_to :cuisine
end
