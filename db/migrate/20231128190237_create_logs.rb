class CreateLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :logs do |t|
      t.string :accion
      t.integer :casillero
      t.datetime :fecha
    end

    add_timestamps :logs, null: true, default: -> { 'CURRENT_TIMESTAMP' }, column_options: { null: false, default: -> { 'CURRENT_TIMESTAMP' }, name: 'fecha' }
  end
end
