Rails.application.routes.draw do
  resources :styles
  resources :memberships
  resources :beer_clubs
  resources :users do
    post 'toggle_activity', on: :member
  end
  
  root 'breweries#index'
  resources :beers
  resources :breweries do
    post 'toggle_activity', on: :member
  end
  get 'ratings', to: 'ratings#index'
  get 'ratings/new', to: 'ratings#new'
  get 'signup', to: 'users#new'
  post 'ratings', to: 'ratings#create'
  get 'signin', to: 'sessions#new'

  post 'places', to: 'places#search'
  delete 'signout', to: 'sessions#destroy'
  
  resources :ratings, only: [:index, :new, :create, :destroy]
  resource :session, only: [:new, :create, :destroy]
  resources :places, only: [:index, :show]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
