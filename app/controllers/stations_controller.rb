class StationsController < ApplicationController

    def show
        @station = LockerStation.find params[:id]
        if @station.last_sensed
            @state_per_locker = @station.last_sensed.split(',')
            @seconds = -((@station.last_updated - DateTime.now).to_i)
        else
            @state_per_locker = [] # Or a default value
            @seconds = 000 # Assuming this is the desired default value
        end
    end
    def index
        @estaciones = LockerStation.all
        @estacion_seleccionada = @estaciones.first
        @lockers = @estacion_seleccionada.lockers
        @locker_stats = []

        @lockers.each do |locker|
            locker_logs = Log.where(accion: 'Cambio a Ocupado', casillero: locker.id).count
            total_changes = Log.where( casillero: locker.id).count
            puts(total_changes, "changes")
            occupied_changes = total_changes.positive? ? total_changes : 0
            puts(locker_logs)
            percentage_occupied_changes = total_changes.zero? ? 0 : (locker_logs.to_f / total_changes) * 100

            @locker_stats << {
              locker_number: locker.number,
              total_changes: total_changes,
              percentage_occupied_changes: percentage_occupied_changes.round(2)
            }
        end
    end
    def lockers_for_estacion
        @estacion_seleccionada = LockerStation.find(params[:estacion_id])
        @lockers = @estacion_seleccionada.lockers
        @locker_stats = []

        @lockers.each do |locker|
            locker_logs = Log.where(accion: 'Cambio a Ocupado', casillero: locker.id).count
            total_changes = Log.where( casillero: locker.id).count
            puts(total_changes, "changes")
            occupied_changes = total_changes.positive? ? total_changes : 0
            puts(locker_logs)
            percentage_occupied_changes = total_changes.zero? ? 0 : (locker_logs.to_f / total_changes) * 100

            @locker_stats << {
              locker_number: locker.number,
              total_changes: total_changes,
              percentage_occupied_changes: percentage_occupied_changes.round(2)
            }
        end
        puts(@locker_stats)
        render json: { lockers: @lockers, lockerStats: @locker_stats }
    end

    def historic_for_locker
        locker_number = params[:locker_number]
        @historic = Log.where(casillero: locker_number)
        render json: { historic: @historic }
    end
end
