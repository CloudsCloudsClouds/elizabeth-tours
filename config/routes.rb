Rails.application.routes.draw do
  namespace :admin do
    resources :add_ons
    resources :bookings
    resources :booking_add_ons
    resources :tours
    resources :users

    get "versions", to: "versions#index"
    get "versions/:id", to: "versions#show", as: :version

    get "reports", to: "reports#index"

    root to: "tours#index"
  end
  resources :tours, only: [ :index, :show ]
  resources :bookings, only: [ :new, :create ]
  resource :session
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  get "admin/expert_system", to: "admin/expert_system#index"

  root "tours#index"
end
