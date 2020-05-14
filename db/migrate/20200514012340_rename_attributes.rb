class RenameAttributes < ActiveRecord::Migration[6.0]
  def change
    rename_column :owns, :users_id, :user_id
    rename_column :owns, :ingredients_id, :ingredient_id
  end
end
