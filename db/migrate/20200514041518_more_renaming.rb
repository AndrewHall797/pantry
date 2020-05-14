class MoreRenaming < ActiveRecord::Migration[6.0]
  def change
    rename_column :book_marks, :recipes_id, :recipe_id
    rename_column :book_marks, :users_id, :user_id

    rename_column :contains, :recipes_id, :recipe_id
    rename_column :contains, :ingredients_id, :ingredient_id

    rename_column :recipes, :users_id, :user_id

    rename_column :steps, :recipes_id, :recipe_id

  end
end
