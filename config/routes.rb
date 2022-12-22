Rails.application.routes.draw do
  root to: 'lists#index'
  resources :lists, only: [:index, :new, :create, :show] do
    resources :bookmarks, only: [:new, :create ] do
      collection do
        get :autocomplete
      end
    end
  end
  resources :bookmarks, only: [ :destroy ]
end
