Rails.application.routes.draw do
  devise_for :users
  
  # Profile completion
  resource :profile, only: [:new, :create]
  
  # Dashboard (home page after login)
  get "dashboard", to: "dashboard#index"
  
  # Root path
  root "dashboard#index"
  
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
