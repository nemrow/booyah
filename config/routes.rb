Booyah::Application.routes.draw do
  root :to => 'welcome#index'

  resources :users do
    resources :addresses
    resources :orders
  end

  resources :pictures, :only => [:create]
  resources :sessions, :only => [:create]

  get 'signup', :to => 'users#new'
  get 'signin', :to => 'sessions#new'
  get 'signout', :to => 'sessions#destroy'
end
