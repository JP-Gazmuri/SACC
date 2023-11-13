Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api, defaults: { format: :json } do
    resources :station do
      get "get_report_deposit", on: :collection
      get "get_report_retire", on: :collection
      get "get_update", on: :collection
      post "report_deposit", on: :collection
      post "report_retire", on: :collection
      post "update", on: :collection
    end
  end 
end
