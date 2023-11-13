class CreateLockers < ActiveRecord::Migration[7.0]
  def change
    create_table :lockers do |t|
      t.references :locker_station, foreign_key: { to_table: :locker_stations }, null: false
      t.integer :number
      t.integer :state, default: 0
      t.integer :height
      t.integer :width
      t.integer :length
      t.timestamps
    end
  end
end
