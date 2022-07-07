Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
  }

  devise_for :customers,skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
  }

  scope module: :public do
    patch 'customers/withdraw'
    resources :customers, only: [:show, :edit, :update] do
      
      get '/followings' => 'relationships#followings'
      get '/followers' => 'relationships#followers'
      resources :relationships, only: [:create, :destroy]
      
    end

    resources :exercises do
      
      resources :comments, only: [:create, :destroy]
      
      resources :favorites, only: [:index, :create, :destroy]

    end
    
    get '/ranking' => 'favorites#ranking'
    
    resources :searches, only: [:index]

  end

    namespace :admin do
    resources :customers, only: [:index, :show, :edit, :update]
  end

  root to: 'homes#top'
end
