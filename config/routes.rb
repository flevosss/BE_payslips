Rails.application.routes.draw do
  devise_for :users
  
  # Profile completion
  resource :profile, only: [:new, :create]
  
  # Dashboard (home page after login)
  get "dashboard", to: "dashboard#index"

  # Employees (Admin only)
  resources :employees, only: [:index]
  
  # User pages
  get "my_payslips", to: "my_payslips#index"
  get "request", to: "request#index"
  get "my_profile", to: "my_profile#index"
  
  # Admin payslips management
  resources :payslips, only: [:index, :new, :create]
  
  # Root path
  root "dashboard#index"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
