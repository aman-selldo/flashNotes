Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "subjects#index"  

  post "/login", to: "auth#login"
  post "/signup", to: "auth#create"

  get "/login", to: "auth#new_login"
  get "/signup", to: "auth#new_signup"
  delete "/logout", to: "auth#logout"


  resources :subjects do
    resources :chapters, only: [:index, :new, :show, :create, :edit, :update, :destroy]
  end


  match "*path", to: "not_found#show", via: :all

end
