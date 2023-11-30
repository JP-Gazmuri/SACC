class EcommercesController < ApplicationController

  def index
    @ecommerces = Ecommerce.all
  end

  def show
    @ecommerce = Ecommerce.find(params[:id])
  end

  def new
    @ecommerce = Ecommerce.new
  end

  def create
    @ecommerce = Ecommerce.new(ecommerce_params)
    @ecommerce.key = rand(100000..999999).to_s
    if @ecommerce.save
      flash[:notice] = 'Ecommerce created successfully.'
      redirect_to @ecommerce
    else
      render :new
    end
  end

  def edit
    @ecommerce = Ecommerce.find(params[:id])
  end

  def update
    @ecommerce = Ecommerce.find(params[:id])
    if @ecommerce.update(ecommerce_params)
      redirect_to @ecommerce
    else
      render :edit
    end
  end

  def destroy
    @ecommerce = Ecommerce.find(params[:id])
    @ecommerce.destroy
    redirect_to ecommerces_url
  end

  private
# Only allow a list of trusted parameters through.
def ecommerce_params
  params.require(:ecommerce).permit(:name, :state)
end
end
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
