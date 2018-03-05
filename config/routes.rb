Rails.application.routes.draw do
  devise_for :users
  get "/create_account", to: "home#info"
  get "/agreement", to: "home#agreement"

  post "/verify_first_stage_info", to: "home#first_stage_info"
  get "/second_stage_info", to: "home#second_stage_info"
  post "/verify_location_info", to: "home#location_info"

  root to: 'home#index'
end
