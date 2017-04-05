class Recipe < ApplicationRecord

  belongs_to :chef

  validates :name, presence: true, length: {  in: 6..50 }
  validates :description, presence: true, length: {  minimum: 12 }
  validates :chef_id, presence: true
end