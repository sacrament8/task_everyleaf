Rails.application.routes.draw do
  root "tasks#index"
  resources :tasks
  resources :users, only: %i(show create new)
end