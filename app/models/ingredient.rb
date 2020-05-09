class Ingredient < ApplicationRecord
  has_many :owns
  has_many :users, through: :owns

  has_many :contains
  has_many :recipes, through: :contains
end
