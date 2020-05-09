class CreateBookMarkeds < ActiveRecord::Migration[6.0]
  def change
    create_table :book_markeds do |t|
      t.integer :user
      t.integer :Recipe

      t.timestamps
    end
  end
end
