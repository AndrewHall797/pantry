class RemoveColumns < ActiveRecord::Migration[6.0]
  def change
    remove_column :book_marks, :user_id
    remove_column :book_marks, :recipe_id

    remove_column :contains, :ingredient_id
    remove_column :contains, :recipe_id

    remove_column :owns, :user_id
    remove_column :owns, :ingredient_id

    remove_column :recipes, :user_id

    remove_column :steps, :recipe_id
  end
end
