class CreateLockerStations < ActiveRecord::Migration[7.0]
  def change
    create_table :locker_stations do |t|
      t.string :name
      t.string :access_key
      t.integer :state, default: 0
      t.datetime :last_updated
      t.timestamps
    end
  end
end
