Rails.application.routes.draw do
  devise_for :users
  get "/create_account", to: "home#info"
  get "/agreement", to: "home#agreement"

  post "/verify_first_stage_info", to: "home#first_stage_info"
  get "/second_stage_info", to: "home#second_stage_info"
  post "/verify_location_info", to: "home#location_info"
  post "/upload_id_proof", to: "home#upload_id_proof"
  get "/complete_verfification", to: "home#complete"
  post "/verify_bank_info", to: "home#bank_details_verification"

  root to: 'home#index'
end
