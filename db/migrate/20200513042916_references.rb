class References < ActiveRecord::Migration[6.0]
  def change
    add_reference :owns, :users, index: true
    add_reference :owns, :ingredients, index: true

    add_reference :contains, :recipes, index: true
    add_reference :contains, :ingredients, index: true

    add_reference :book_marks, :users, index: true
    add_reference :book_marks, :recipes, index: true

    add_reference :recipes, :users, index: true

    add_reference :steps, :recipes, index: true
  end
end
