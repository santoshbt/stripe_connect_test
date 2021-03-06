Rails.application.routes.draw do
  devise_for :users
  get "/create_account", to: "home#info"
  get "/agreement", to: "home#agreement"

  post "/verify_first_stage_info", to: "home#first_stage_info"
  get "/second_stage_info", to: "home#second_stage_info"
  post "/verify_location_info", to: "home#location_info"
  post "/upload_id_proof", to: "home#upload_id_proof"
  get "/complete_verfification", to: "home#complete"
  get "/edit_additional_info", to: "home#edit_additional_info"
  post "/verify_bank_info", to: "home#bank_details_verification"

  resources :payments do
    collection do
      get :list
    end
    member do
      get :pay 
      post :charge     
    end
  end

  root to: 'home#index'
end
