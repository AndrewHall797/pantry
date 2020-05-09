class User < ApplicationRecord
  has_many :owns
  has_many :ingredients, through: :owns

  has_many :book_marks
  has_many :recipes, through: :book_marks
end
