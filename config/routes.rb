Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "stations#index"
  namespace :api, defaults: { format: :json } do
    resources :station do
      get "get_report_deposit", on: :collection
      get "get_report_retire", on: :collection
      get "get_update", on: :collection
    end


    resources :ecommerce do
      post "available_lockers",on: :collection
      post "reserve_locker", on: :collection
      post "confirm_order", on: :collection
      post "cancel_order", on: :collection
      post "historic_orders", on: :collection
      post "active_orders", on: :collection
      post "order_state", on: :collection
    end


    resources :sacc do
      get "logs", on: :collection
    end
  end

  resources :stations
  # config/routes.rb
  get 'stations/lockers_for_estacion/:estacion_id', to: 'stations#lockers_for_estacion', defaults: { format: :json }
  # En tu archivo routes.rb
  get 'stations/historic_for_locker/:locker_number', to: 'stations#historic_for_locker', defaults: { format: :json }

end
