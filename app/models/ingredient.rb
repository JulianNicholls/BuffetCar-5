class Ingredient < ApplicationRecord
  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients

  default_scope -> { order :name }

  validates :name,
            presence: true,
            length: { in: 3..25 },
            uniqueness: { case_sensitive: false }
end
