Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  get '/my', to: 'users#my_page', as: :my_page
  get '/my/info', to: 'users#my_info', as: :my_page_info
  get '/login', to: 'sessions#new', as: :login
  delete '/logout', to: 'sessions#destroy', as: :logout

  get '/register/1', to: 'confirmations#new', as: :register_step1
  post '/register/2', to: 'confirmations#mail_register', as: :register_step2

  get '/registation/3code=:confirm_token', to: 'users#registation', as: :registation

  resources :jobs
  get 'detail/:id', to: 'jobs#show', as: :job_detail

  get 'jobs/city/:converted_name', to: 'jobs#city_jobs', as: :city_jobs
  get 'jobs/industry/:converted_name', to: 'jobs#industry_jobs', as: :industry_jobs
  get 'jobs/company/:converted_name', to: 'jobs#company_jobs', as: :company_jobs

  resources :confirmations
  resources :top_pages
  resources :industries
  resources :cities
  root to: "top_pages#index"
end


