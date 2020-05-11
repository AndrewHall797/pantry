class CreateInPantries < ActiveRecord::Migration[6.0]
  def change
    create_table :in_pantries do |t|
      t.integer :user
      t.integer :ingredient
      t.decimal :weight_value, precision: 10, scale: 2
      t.string :weight_unit
      t.decimal :volume_value, precision: 10, scale: 2
      t.string :volume_unit

      t.timestamps
    end
  end
end
