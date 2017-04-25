class Comment < ApplicationRecord
  belongs_to :chef
  belongs_to :recipe

  default_scope -> { order(updated_at: :desc) }

  validates :content, presence: true, length: { in: 4..160 }
  validates :chef_id, presence: true
  validates :recipe_id, presence: true
end
