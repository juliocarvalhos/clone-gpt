Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get '/users/sign_out', to: 'devise/sessions#destroy'
  end
  resources :messages
  resources :conversations
  resources :conversations do
    resources :messages, only: [:create, :new]
  end
  root "conversations#new"

end

