Rails.application.routes.draw do
  root "tasks#index"
  resources :tasks
  namespace :admin do
    resources :users
  end
  resources :users
  resources :sessions, only: %i(new create destroy)
end