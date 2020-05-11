class Rename < ActiveRecord::Migration[6.0]
  def change
    rename_column :book_marks, :user, :user_id
    rename_column :book_marks, :Recipe, :recipe_id

    rename_column :contains, :user, :ingredient_id
    rename_column :contains, :recipe, :recipe_id

    rename_column :owns, :user, :user_id
    rename_column :owns, :ingredient, :ingredient_id

    rename_column :recipes, :creator, :user_id
  end
end
