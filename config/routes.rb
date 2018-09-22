Rails.application.routes.draw do
  resources :memberships
  resources :beer_clubs
  resources :users
  root 'breweries#index'
  resources :beers
  resources :breweries
  get 'ratings', to: 'ratings#index'
  get 'ratings/new', to: 'ratings#new'
  get 'signup', to: 'users#new'
  post 'ratings', to: 'ratings#create'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
  
  resources :ratings, only: [:index, :new, :create, :destroy]
  resource :session, only: [:new, :create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
