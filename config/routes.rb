Rails.application.routes.draw do
  post 'register', to: 'authentication#register'
  post 'login', to: 'authentication#login'
  
  resources :users, only: [:show, :update, :destroy]
  resources :problems, only: [:index, :show, :create, :update, :destroy]
  resources :submissions, only: [:create, :show, :index]
  resources :test_cases, only: [:index, :new, :create, :destroy]
end
