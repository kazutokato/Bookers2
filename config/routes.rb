Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'
  get 'home/about'=> 'homes#about'
  resources :homes, only: [:top,:about]
  resources :books do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  resources :users, only: [:index, :show, :edit, :update]

  post 'follow/:id' => 'relationships#follow', as: 'follow'
  post 'unfollow/:id' => 'relationships#unfollow', as: 'unfollow'
  get 'follower/:id' => 'users#follower', as: 'follower'
  get 'followed/:id' => 'users#followed', as: 'followed'

end
