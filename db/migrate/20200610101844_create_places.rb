class CreatePlaces < ActiveRecord::Migration[6.0]
  def change
    create_table :places do |t|
      t.string :address,            null: false
      t.float :latitude,            null: false
      t.float :longitude,           null: false
      t.time :start,                null: false
      t.time :last,                 null: false
      t.references :restaurant, null: false, foriegn_key: true
      t.timestamps
    end
  end
end