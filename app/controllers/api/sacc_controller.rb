module Api
    class SaccController < ApplicationController
        skip_before_action :verify_authenticity_token

        def index
            lockers = Locker.where(propietario: "G13").order(:created_at)
            json_array = lockers.map do |obj|
              {
                id: obj.id,
                estado: obj.estado,
                codigo_d: obj.codigo_d,
                codigo_r: obj.codigo_r,
                propietario: obj.propietario,
                alto: obj.alto,
                ancho: obj.ancho,
                largo: obj.largo,
                sensorm: obj.sensorm,
                sensors: obj.sensors
              }
            end

            render json: { msg: "ok", data: json_array }
        end

        def logs
            if params[:inicio].present?
                from = DateTime.parse(params[:desde])
                @logs = Log.where('fecha > ?', from)
            else
                @logs = Log.all
            end

            render json: {msg:"ok",data: @logs}

        end

        def update
            id = params[:id]
            locker = Locker.find id
            possible_values = ["estado", "codigo_r", "codigo_d"]

            possible_values.each do |param_name|
                if params.key?(param_name)
                    locker.send("#{param_name}=", params[param_name])
                end
            end
            locker.save
            render json: {status: "ok"}
        end
    end
end
