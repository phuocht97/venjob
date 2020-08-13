Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  match '/my', to: 'users#my_page', via: 'get', as: :my_page
  match '/my/info', to: 'users#my_info', via: 'get', as: :my_page_info
  match '/login', to: 'sessions#new', via: 'get', as: :login
  match '/logout', to: 'sessions#destroy', via: 'delete', as: :logout

  resources :jobs
  resources :top_pages
  resources :industries
  resources :cities
  root to: "top_pages#index"
end
