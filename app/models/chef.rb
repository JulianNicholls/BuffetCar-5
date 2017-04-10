class Chef < ApplicationRecord
  before_save { self.email.downcase! }

  has_many :recipes

  has_secure_password

  # A verrry minimal EMAIL Regex
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :name, presence: true, length: { in: 5..60 }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true  # allow nill only actions on edit
  validates :email,
    presence:   true,
    length:     { minimum: 8 },
    format:     { with: EMAIL_REGEX },
    uniqueness: { case_sensitive: false }
end
