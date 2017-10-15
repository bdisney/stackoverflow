require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  root 'questions#index'

  devise_scope :user do
    post '/register' => 'omniauth_callbacks#register'
  end

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
    end
  end

  concern :commentable do
    resources :comments, only: [:new, :create, :destroy], shallow: true
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers,
              only: [:create, :edit, :update, :destroy],
              concerns: [:votable, :commentable],
              shallow: true do
                patch :accept, on: :member
              end
  end

  resources :subscriptions, only: [:create, :destroy]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end
      resources :questions do
        resources :answers, shallow: true
      end
    end
  end

  mount ActionCable.server => '/cable'
end
