Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    get "static_pages/contact"
    root "microposts#index"
    get 'contact', to: 'static_pages#contact'
    resources :microposts, only: [:index]
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
