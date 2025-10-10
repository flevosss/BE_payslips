Rails.application.routes.draw do
  devise_for :users
  
  # Profile completion
  resource :profile, only: [:new, :create]
  
  # Dashboard (home page after login)
  get "dashboard", to: "dashboard#index"

  # Employees (Admin only)
  resources :employees, only: [:index, :show, :edit, :update, :destroy]
  
  # User pages
  get "my_payslips", to: "my_payslips#index"
  get "request", to: "request#index"
  resource :my_profile, only: [:show, :edit, :update], controller: 'my_profile' #could also change the controller name to profiles because it automatically pluralizes it and doesnt find the controller named 
  
  # Admin payslips management
  resources :payslips, only: [:index, :new, :create]
  
  # Root path
  root "dashboard#index"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
