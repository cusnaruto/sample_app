Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    get "signup", to: "users#new"
    get "static_pages/contact"
    get "contact", to: "static_pages#contact"
    root "microposts#index"
    resources :microposts, only: [:index]
    resources :users, only: [:show, :new, :create]
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
