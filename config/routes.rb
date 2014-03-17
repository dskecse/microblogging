Microblogging::Application.routes.draw do
  resources :users
  resources :sessions,   only: [:new, :create, :destroy]
  resources :microposts, only: [:create, :destroy]

  root 'static_pages#home'
  delete '/signout', to: 'sessions#destroy'
  get '/signin',  to: 'sessions#new'
  get '/signup',  to: 'users#new'
  get '/help',    to: 'static_pages#help'
  get '/about',   to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
end
