Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :jobs
  resources :top_pages
  root to: "top_pages#index"
end
