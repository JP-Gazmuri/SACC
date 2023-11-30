class StationsController < ApplicationController

    def show
        @station = LockerStation.find params[:id]
        @state_per_locker = @station.last_sensed.split(',')
        @seconds = -((@station.last_updated - DateTime.now).to_i)
    end
    def index
        @estaciones = LockerStation.all
        @estacion_seleccionada = @estaciones.first
        @lockers = @estacion_seleccionada.lockers
        @locker_stats = []

        @lockers.each do |locker|
            locker_logs = Log.where(accion: 'Cambio a Ocupado', casillero: locker.id)
            total_changes = locker_logs.count
            occupied_changes = total_changes.positive? ? total_changes : 0
            percentage_occupied_changes = total_changes.zero? ? 0 : (occupied_changes.to_f / total_changes) * 100

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
            locker_logs = Log.where(accion: 'Cambio a Ocupado', casillero: locker.id)
            total_changes = locker_logs.count
            occupied_changes = total_changes.positive? ? total_changes : 0
            percentage_occupied_changes = total_changes.zero? ? 0 : (occupied_changes.to_f / total_changes) * 100

            @locker_stats << {
              locker_number: locker.number,
              total_changes: total_changes,
              percentage_occupied_changes: percentage_occupied_changes.round(2)
            }
        end
        render json: { lockers: @lockers, lockerStats: @locker_stats }
    end
    def historic_for_locker
        locker_number = params[:locker_number]
        @historic = Log.where(casillero: locker_number)
        render json: { historic: @historic }
    end
end
