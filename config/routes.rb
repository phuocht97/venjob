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

  get '/forgot_password', to: 'reset_passwords#reset_password', as: :reset_password_step1
  post '/forgot_password', to: 'reset_passwords#sending_email', as: :reset_password_step2

  get '/reset_password', to: 'reset_passwords#edit', as: :reset_password_final
  patch '/update', to: 'reset_passwords#update', as: :update_forgot_pass

  get '/registation/3', to: 'users#registation', as: :registation

  get 'apply', to: 'applied_jobs#new', as: :apply_job

  post 'confirm', to: 'applied_jobs#confirmation', as: :confirm_job
  post 'done', to: 'applied_jobs#create', as: :finished_apply

  get '/my/jobs', to: 'applied_jobs#show', as: :my_jobs

  resources :jobs
  get 'detail/:id', to: 'jobs#show', as: :job_detail

  get 'jobs/city/:converted_name', to: 'jobs#city_jobs', as: :city_jobs
  get 'jobs/industry/:converted_name', to: 'jobs#industry_jobs', as: :industry_jobs
  get 'jobs/company/:converted_name', to: 'jobs#company_jobs', as: :company_jobs

  resources :admins, only: [:new, :create, :destroy, :index]
  get 'admin/login', to: 'admins#new', as: :admin_login
  delete 'admin/logout', to: 'admins#destroy', as: :admin_logout
  get 'admin/applies', to: 'admins#index', as: :admin_page
  match 'admin/search', to: 'admins#search', via: [:get, :post], as: :admin_search

  get 'download-csv', to: 'admins#download_csv', as: :download_csv

  resources :applied_jobs, only: [:new, :create]
  resources :reset_passwords, only: [:edit, :update]
  resources :confirmations, only: [:new]
  resources :top_pages, only: [:index]
  resources :industries, only: [:index]
  resources :cities, only: [:index]
  root to: "top_pages#index"
end


