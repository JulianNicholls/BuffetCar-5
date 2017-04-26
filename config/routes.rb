Rails.application.routes.draw do
  resources :recipes do
    resources :comments, only: :create
  end

  resources :chefs, except: [:new]
  resources :ingredients, except:[:destroy]

  get 'pages/home'
  get '/about',     to: 'pages#about'

  get '/signup',    to: 'chefs#new'

  get '/login',     to: 'sessions#new'
  post '/login',    to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  root 'pages#home'

  mount ActionCable.server => '/cable'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
