class Place < ApplicationRecord
  validates :address,  presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :start, presence: true
  validates :last, presence: true
  belongs_to :restaurant, optional: true
end
