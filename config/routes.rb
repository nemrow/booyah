Booyah::Application.routes.draw do
  get "sessions/create"

  get "sessions/destroy"

  root :to => 'welcome#index'

  resources :users do
    resources :addresses
  end

  resources :pictures, :only => [:create]

  get 'signup', :to => 'users#new'
  get 'signin', :to => 'sessions#new'
  get 'signout', :to => 'sessions#destroy'
end
