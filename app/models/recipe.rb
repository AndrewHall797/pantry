class Recipe < ApplicationRecord
  has_many :contain
  has_many :ingredients, through: :contains

  belongs_to :user

  has_many :book_marks
  has_many :users through: :book_marks

  has_many :steps
end
