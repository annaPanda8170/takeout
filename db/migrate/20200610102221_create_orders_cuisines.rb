class CreateOrdersCuisines < ActiveRecord::Migration[6.0]
  def change
    create_table :orders_cuisines do |t|
      t.references :order, null: false, foriegn_key: true
      t.references :cuisine, null: false, foriegn_key: true
      t.integer :number, null: false
      t.timestamps
    end
  end
end