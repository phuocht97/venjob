Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :jobs
  get 'jobs/city/:name', to: 'jobs#city_jobs', as: :city_jobs
  get 'jobs/industry/:id', to: 'jobs#industry_jobs', as: :industry_jobs

  resources :top_pages
  resources :industries
  resources :cities
  root to: "top_pages#index"
end
