Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, only: [:create, :edit, :update, :destroy], concerns: :votable, shallow: true do
      patch :accept, on: :member
    end
  end
end
