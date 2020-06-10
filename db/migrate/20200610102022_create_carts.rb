class CreateCarts < ActiveRecord::Migration[6.0]
  def change
    create_table :carts do |t|
      t.integer :restaurant_id, null: false
      t.timestamps
    end
  end
end