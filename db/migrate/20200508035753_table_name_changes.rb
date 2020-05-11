class TableNameChanges < ActiveRecord::Migration[6.0]
  def change
    rename_table :book_markeds, :book_marks
    rename_table :in_recipes, :contains
    rename_table :in_pantries, :owns
  end
end
