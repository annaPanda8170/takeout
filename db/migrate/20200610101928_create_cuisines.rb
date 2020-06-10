class CreateCuisines < ActiveRecord::Migration[6.0]
  def change
    create_table :cuisines do |t|
      t.string :name,    null: false
      t.string :discription
      t.string :image
      t.integer :price, null: false
      t.references :restaurant, foriegn_key: true
      t.integer :cook_time, null: false
      t.timestamps
    end
  end
end