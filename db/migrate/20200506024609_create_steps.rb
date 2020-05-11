class CreateSteps < ActiveRecord::Migration[6.0]
  def change
    create_table :steps do |t|
      t.string :description
      t.integer :number
      t.integer :recipeOwner

      t.timestamps
    end
  end
end
