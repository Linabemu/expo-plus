Rails.application.routes.draw do
  # get 'followers/create'
  # get 'followers/new'
  # get 'messages/create'
  # get 'messages/destroy'
  # get 'reviews/create'
  # get 'proposals/create'
  # get 'wishes/create'
  # get 'profiles/show'
  # get 'expos/index'
  # get 'expos/show'
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :expos, only: %i[show index] do
    resources :wishes, only: :create
    resources :proposals, only: %i[create index]
    resources :reviews, only: %i[new create]
  end

  resources :wishes, only: :destroy

  resources :proposals, only: :destroy do
    resources :messages, only: :create
    resources :participants, only: :create
  end

  resources :users, only: %i[show edit update index] do
    resources :followings, only: %i[create new]
    member do
      get :profile
    end
  end

  resources :messages, only: :destroy
end
