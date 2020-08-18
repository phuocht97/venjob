Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  get '/my', to: 'users#my_page', as: :my_page
  get '/my/info', to: 'users#my_info', as: :my_page_info
  get '/login', to: 'sessions#new', as: :login
  match '/logout', to: 'sessions#destroy', via: 'delete', as: :logout

  resources :jobs
  resources :top_pages
  resources :industries
  resources :cities
  root to: "top_pages#index"
end
