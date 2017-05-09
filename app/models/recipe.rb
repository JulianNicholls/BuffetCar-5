class Recipe < ApplicationRecord
  belongs_to :chef

  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients
  has_many :comments, dependent: :destroy
  has_many :likes,    dependent: :destroy

  default_scope -> { order(updated_at: :desc) }

  validates :name, presence: true, length: {  in: 6..50 }
  validates :description, presence: true, length: {  minimum: 12 }
  validates :chef_id, presence: true

  def upvotes
    self.likes.where(upvote: true).size
  end

  def downvotes
    self.likes.where(upvote: false).size
  end
end
