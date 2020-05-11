class CreateRecipes < ActiveRecord::Migration[6.0]
  def change
    create_table :recipes do |t|
      t.string :name
      t.integer :time
      t.string :creator
      t.boolean :public

      t.timestamps
    end
  end
end
