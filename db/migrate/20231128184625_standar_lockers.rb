class StandarLockers < ActiveRecord::Migration[7.0]
  def change
    add_column :lockers, :estado, :string, default: "Disponible"
    add_column :lockers, :sensorm, :string, default: "Cerrado"
    add_column :lockers, :sensors, :integer, default: 0
    add_column :lockers, :propietario, :string, default: "G13"
    add_column :lockers, :codigo_d, :string, default: "000000"
    add_column :lockers, :codigo_r, :string, default: "000000"
    add_column :lockers, :already_informed, :integer, default: 0
    rename_column :lockers, :height, :alto
    rename_column :lockers, :width, :ancho
    rename_column :lockers, :length, :largo

  end
end
