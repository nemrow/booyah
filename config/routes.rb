Booyah::Application.routes.draw do
  get "preapproval/new"
  get "emails/basic_template"

  root :to => 'welcome#index'

  resources :users do
    resources :addresses
    resources :orders
    resources :preapproval, :only => [:show]
    resources :credits, :only => [:create]
    put 'update_password', :to => 'users#update_password'
    get 'edit_password', :to => 'users#edit_password'
  end

  resources :admin_users, :only => [:index, :show]
  resources :admin_orders, :only => [:index, :show]

  resources :pictures, :only => [:create] do
    get 'orders'
  end
  resources :sessions, :only => [:create]

  get 'signup', :to => 'users#new'
  get 'signin', :to => 'sessions#new'
  get 'signout', :to => 'sessions#destroy'
  get 'contact', :to => 'welcome#contact'
  get 'permission_denied', :to => 'errors#permission_denied'
  get 'forgot_password', :to => 'users#forgot_password'
  post 'reset_password', :to => 'users#reset_password' 
end
