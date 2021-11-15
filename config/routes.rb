Rails.application.routes.draw do
  devise_for :users
  root 'books#index'
  resources :book_instances do
    member do
      get 'lending'
      post 'lend'
      post 'return'
      post 'reserve'
      post 'dereserve'
    end
  end
  resources :users
  resources :authors
  resources :books
  resources :publishers
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
