Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    root to: 'devise/sessions#new'

    match '/logout' => 'devise/sessions#destroy', via: [:get, :delete]
  end

  resources :hotels, only: [:index] do
    collection do
      get :search
    end
  end

  resources :checkins, only: [:index, :create]

  resources :users, only: :none do
    member do
      get :checkins
    end
  end
end
