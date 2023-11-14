class AddLastSensedToLockerStations < ActiveRecord::Migration[7.0]
  def change
    add_column :locker_stations, :last_sensed, :string
  end
end
