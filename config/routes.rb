Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  resources :users do
    resources :jogs
  end
  
  post 'login', to: 'authentication#login'
  get 'me', to: 'users#me'
  put 'role/:id', to: 'users#update_role'
  get 'users/users/all', to: 'users#users'
  
end
