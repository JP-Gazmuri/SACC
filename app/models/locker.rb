class Locker < ApplicationRecord
    belongs_to :locker_station
    has_many :orders
    before_save :update_states
    after_save :create_log

    enum state: {libre:0, confirmado: 1, ocupado:2, estacion_no_activa: 3}
    enum sensors: {Vacio: 0,Lleno:1}

    def self.find_smallest_locker(object_dimensions,station)

      available_lockers = Locker.where(locker_station: station).where(state: 0)

      smallest_locker = nil
      smallest_volume = nil

      # All six possible orientations
      orientations = [
        [:largo, :ancho, :alto],
        [:largo, :alto, :ancho],
        [:ancho, :largo, :alto],
        [:ancho, :alto, :largo],
        [:alto, :largo, :ancho],
        [:alto, :ancho, :largo]
      ]

      available_lockers.each do |locker|
        orientations.each do |orientation|
          # Check if the locker can accommodate the object
          if locker_can_accommodate?(locker, object_dimensions, orientation)
            # Calculate the volume of the locker
            locker_volume = locker.send(orientation[0]) * locker.send(orientation[1]) * locker.send(orientation[2])

            # If the smallest_volume is not set or the current locker is smaller, update the variables
            if smallest_volume.nil? || locker_volume < smallest_volume
              smallest_volume = locker_volume
              smallest_locker = locker
            end
          end
        end
      end

      smallest_locker
    end

    private

    def create_log
      changes = saved_changes
      if changes.key?("estado")
        if changes["estado"][0] != changes["estado"][1]
          l = Log.new
          l.casillero = self.id
          l.accion = "Cambio a #{changes["estado"][1]}"
          l.save
        end
      end
    end

    def update_states
      changes = self.changes
      if changes.key?("state")
        if changes["state"][1] ==  "libre"
          self.estado = "Disponible"
          self.already_informed = 0
          self.codigo_r = ""
          self.codigo_d = ""
        elsif changes["state"][1] ==  "confirmado"
          self.estado = "Reservado"
        elsif  changes["state"][1] ==  "ocupado"
          self.estado = "Ocupado"
        end
      elsif changes.key?("estado")
        if changes["estado"][1] ==  "Disponible"
          self.state = "libre"
          self.already_informed = 0
          self.codigo_r = ""
          self.codigo_d = ""
        elsif changes["estado"][1] ==  "Reservado"
          self.state = "confirmado"
        elsif  changes["estado"][1] ==  "Ocupado"
          self.state = "ocupado"
        end
      end
    end

    def self.locker_can_accommodate?(locker, object_dimensions, orientation)
      # Check if the locker can accommodate the object based on the given orientation
      locker.send(orientation[0]) >= object_dimensions[:largo] &&
        locker.send(orientation[1]) >= object_dimensions[:ancho] &&
        locker.send(orientation[2]) >= object_dimensions[:alto]
    end

end
