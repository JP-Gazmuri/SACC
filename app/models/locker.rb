class Locker < ApplicationRecord
    belongs_to :locker_station
    has_many :orders

      
    def self.find_smallest_locker(object_dimensions,station)
      
      available_lockers = Locker.where(locker_station: station).where(state: 0) 

      smallest_locker = nil
      smallest_volume = nil
  
      # All six possible orientations
      orientations = [
        [:length, :width, :height],
        [:length, :height, :width],
        [:width, :length, :height],
        [:width, :height, :length],
        [:height, :length, :width],
        [:height, :width, :length]
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
  
    def self.locker_can_accommodate?(locker, object_dimensions, orientation)
      # Check if the locker can accommodate the object based on the given orientation
      locker.send(orientation[0]) >= object_dimensions[:length] &&
        locker.send(orientation[1]) >= object_dimensions[:width] &&
        locker.send(orientation[2]) >= object_dimensions[:height]
    end
   
end