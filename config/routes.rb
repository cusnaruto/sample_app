Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "static_pages/contact"
    get "/login", to: "sessions#new"
    get "contact", to: "static_pages#contact"
    get "signup", to: "users#new"

    post "signup", to: "users#create"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resources :microposts, only: %i(index create destroy)
    resources :sessions, only: [:show]
    resources :users, only: %i(index show create destroy edit update)
    resources :account_activations, only: :edit
    resources :password_resets, only: %i(new create edit update)
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
