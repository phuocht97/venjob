Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :jobs
  get 'jobs/cities/:id', to: 'jobs#city_jobs'

  resources :top_pages
  resources :industries
  resources :cities
  root to: "top_pages#index"
end
