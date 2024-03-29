Rails.application.routes.draw do
  root to: 'lists#index'
  resources :lists, only: [:index, :new, :create, :show, :destroy] do
    collection do
      get :autocomplete
    end
    resources :bookmarks, only: [:new, :create ]
  end
  resources :bookmarks, only: [ :destroy ]
end
