Rails.application.routes.draw do
  root "tasks#index"
  resources :tasks do
    get 'expired', on: :collection
  end
  namespace :admin do
    resources :users do
      get :have_tasks, on: :member
    end

  end
  resources :users
  resources :sessions, only: %i(new create destroy)
end