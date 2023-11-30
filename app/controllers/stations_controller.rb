class StationsController < ApplicationController


    require 'httparty'
    require 'json'

    ROUTES = {G11:{lockers:"", logs:""},G14:{lockers: "https://pds3.vercel.app/estaciones/id/casilleros", logs:"https://pds3.vercel.app/api/logs"}}


    def show
        @station = LockerStation.find params[:id]
        @state_per_locker = @station.last_sensed.split(',')
        @seconds = -((@station.last_updated - DateTime.now).to_i)
    end

    def new
        @station = LockerStation.new
    end

    def create

        @station = LockerStation.new
        @station.name = params[:station][:name]
        response = HTTParty.get(params[:station][:url])


        response_body = response.body
        json_data = JSON.parse(response_body)








    end

end
