Rails.application.routes.draw do
  devise_for :users
  ActiveAdmin.routes(self)
  root to: "visitors#index"

  devise_scope :user do
    get "/users/sign_out" => "devise/sessions#destroy"
  end

  namespace :api do
    api_version(module: "V1", path: { value: "v1" }) do
      resources :designation_accounts, only: :create
      resources :designation_profiles, only: :create
      resources :donations, only: :create
      resources :donor_accounts, only: :create
      resource :query, only: :show
    end
  end

  scope module: :dashboard do
    resources :designation_profiles do
      scope module: :designation_profiles do
        resources :designation_accounts, only: [] do
          scope module: :designation_accounts do
            resources :donations, only: [:index] do
            end
          end
        end
      end
    end
  end
end
