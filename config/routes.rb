Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
<<<<<<< HEAD
    get "signup", to: "users#new"
    get "static_pages/contact"
    get "contact", to: "static_pages#contact"
    root "microposts#index"
    resources :microposts, only: [:index]
    resources :users, only: [:show, :new, :create]
=======
    root "microposts#index"

    get "static_pages/contact"
    get "/login", to: "sessions#new"
    get "contact", to: "static_pages#contact"

    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resources :microposts, only: [:index]
    resources :sessions, only: [:show]
    resources :users
>>>>>>> 186e71b (Chapter 8)
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
