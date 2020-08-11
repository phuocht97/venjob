Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :jobs
  get 'jobs/city/:converted_name', to: 'jobs#city_jobs', as: :city_jobs
  get 'jobs/industry/:converted_name', to: 'jobs#industry_jobs', as: :industry_jobs
  get 'jobs/company/:converted_name', to: 'jobs#company_jobs', as: :company_jobs

  get 'detail/:id', to: 'jobs#detail', as: :job_detail

  resources :top_pages
  resources :industries
  resources :cities
  root to: "top_pages#index"
end
