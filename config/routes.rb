Rails.application.routes.draw do
  resources :recipes
  resources :chefs, except: [:new]

  get 'pages/home'

  get '/signup', to: 'chefs#new'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  root 'pages#home'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
