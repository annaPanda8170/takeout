Rails.application.routes.draw do
  devise_for :restaurants, controllers: {
    registrations: 'restaurants/registrations',
    sessions: "restaurants/sessions",
  }
  devise_scope :restaurant do
    get 'places', to: 'restaurants/registrations#new_place'
    post 'places', to: 'restaurants/registrations#create_place'
  end
  root "orders#index"
  resources :cuisines
  # resources :main, only: :index
  resources :orders do
    collection do 
      get "get_directions"
      get "get_restaurants"
      get "post_latlng"
      get "pay_index"
      get "pay_new"
      post "pay_create"
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end