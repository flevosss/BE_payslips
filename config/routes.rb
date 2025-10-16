Rails.application.routes.draw do
  devise_for :users
  
  # Profile completion
  resource :profile, only: [:new, :create]
  
  # Dashboard (home page after login)
  get "dashboard", to: "dashboard#index"

  # Employees (Admin only)
  resources :employees, only: [:index, :show, :edit, :update, :destroy]
  
  # User pages
  resources :my_payslips, only: [:index, :show]
  get "request", to: "request#index"
  post "request", to: "request#create_leave_request"
  resource :my_profile, only: [:show, :edit, :update], controller: 'my_profile' #could also change the controller name to profiles because it automatically pluralizes it and doesnt find the controller named 
  
  # Admin payslips management
  resources :payslips, only: [:index, :new, :create, :show]
  
  # Admin leave requests management (Admin only)
  resources :admin_leaves, only: [:index] do
    member do
      patch :approve
      patch :reject
    end
  end
  
  # Root path
  root "dashboard#index"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
