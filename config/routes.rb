Rails.application.routes.draw do
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

  mount ActionCable.server => '/cable'
end
