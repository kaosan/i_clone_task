Rails.application.routes.draw do
  root to: 'images#top'
  resources :favorites, only:[:create, :destroy]
  resources :sessions, only: [:new, :create, :destroy]
  resources :users
  resources :images do
    collection do
      post :confirm
    end
  end
end
