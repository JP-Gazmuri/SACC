class StationsController < ApplicationController

    def show
        @station = LockerStation.find params[:id]
        @state_per_locker = @station.last_sensed.split(',')
        @seconds = -((@station.last_updated - DateTime.now).to_i)
    end

end
