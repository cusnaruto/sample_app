Rails.application.routes.draw do
  get 'users/show'
  get 'static_pages/signup'
  post 'static_pages/create'

  resources :users, only: [:show]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
