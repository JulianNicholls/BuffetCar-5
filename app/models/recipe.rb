class Recipe < ApplicationRecord

  validates :name, presence: true, length: {  in: 6..50 }
  validates :description, presence: true, length: {  minimum: 12 }
end
