Rails.application.routes.draw do
  devise_for :users
  get "/create_account", to: "home#info"

  root to: 'home#index'
end
