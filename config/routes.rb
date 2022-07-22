Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
  }

  devise_for :customers,skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
  }

  devise_scope :customer do
    post 'public/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end

  scope module: :public do

    get '/notifications' => 'notifications#index'
    delete 'notifications/destroy_all'

    patch 'customers/withdraw/:id' => 'customers#withdraw', as: 'withdraw'
    resources :customers, only: [:show, :edit, :update] do

      get '/followings' => 'relationships#followings'
      get '/followers' => 'relationships#followers'
      resource :relationships, only: [:create, :destroy]

    end
    resources :exercises do

      resources :comments, only: [:create, :destroy]

      resource :favorites, only: [:create, :destroy]
      get 'favorites_all' => 'favorites#favorites_all', as: 'favorites_all'

    end

    get '/ranking' => 'favorites#ranking'

    resources :searches, only: [:index]

  end

  namespace :admin do
    get '/searches' => 'customers#searches'
    resources :customers, only: [:index, :show, :update]
  end

  root to: 'homes#top'
end
