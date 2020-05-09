class RenameRecipeOwnderToRecipeId < ActiveRecord::Migration[6.0]
  def change
    rename_column :steps, :recipeOwner, :recipe_id
  end
end
