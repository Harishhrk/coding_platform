Rails.application.routes.draw do
  post 'register', to: 'authentication#register'
  post 'login', to: 'authentication#login'
  
  resources :users, only: [:show, :update, :destroy]

  resources :problems, only: [:index, :show, :create, :update, :destroy] do
    resources :test_cases, only: [:create, :index, :show, :destroy]  # Nested routes for test cases
  end

  resources :submissions, only: [:create, :show, :index]
end
