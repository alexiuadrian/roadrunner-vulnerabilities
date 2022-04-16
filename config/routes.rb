Rails.application.routes.draw do
  post "/login", to: "users#login"
  get "/auto_login", to: "users#auto_login"
  post "/register", to: "users#create"
  post "/user_roles/:id", to: "users#user_roles"
  get "/get_user_roles/:id", to: "users#get_user_roles"
  resources :users

  # API routes
  namespace :api, defaults: { format: :json } do
    resources :runs, except: [:destroy]
    delete "/runs", to: "runs#destroy"
    get "/report", to: "runs#report"
  end
end
