class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :card
      t.time :time, null: false
      t.timestamps
    end
  end
end