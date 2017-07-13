Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'
  resources :questions do
    resources :answers, only: [:create, :destroy], shallow: true
  end
end
