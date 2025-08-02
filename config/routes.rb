Rails.application.routes.draw do
  devise_for :users
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  root to: 'books#index'
  resources :users, only: %i(index show)
  resources :books do
    resources :comments, only: [:create]
  end
  resources :reports do
    resources :comments, only: [:create]
  end
  resources :comments, only: %i(edit update destroy)
end
