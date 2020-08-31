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

  get 'apply', to: 'job_applieds#new', as: :apply_job

  post 'confirm', to: 'job_applieds#confirmation', as: :confirm_job
  post 'done', to: 'job_applieds#create', as: :finished_apply

  get '/my/jobs', to: 'job_applieds#show', as: :my_jobs

  resources :jobs
  get 'detail/:id', to: 'jobs#show', as: :job_detail

  get 'jobs/city/:converted_name', to: 'jobs#city_jobs', as: :city_jobs
  get 'jobs/industry/:converted_name', to: 'jobs#industry_jobs', as: :industry_jobs
  get 'jobs/company/:converted_name', to: 'jobs#company_jobs', as: :company_jobs

  post 'favorite_job', to: 'job_favorites#create', as: :favorite_job
  delete 'unfavorite_job', to: 'job_favorites#destroy', as: :unfavorite_job
  get 'favorite', to: 'job_favorites#show', as: :my_favorite_job

  resources :job_favorites, only: [:create, :destroy]
  resources :job_applieds,only: [:new, :create]
  resources :reset_passwords, only: [:edit, :update]
  resources :confirmations, only: [:new]
  resources :top_pages, only: [:index]
  resources :industries, only: [:index]
  resources :cities, only: [:index]
  root to: "top_pages#index"
end


