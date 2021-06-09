# frozen_string_literal: true

Rails.application.routes.draw do
  constraints subdomain: /./ do
    devise_for :users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)
    root to: redirect('/admin')
    namespace :api do
      api_version(module: 'V1', path: { value: 'v1' }) do
        resources :balances, only: :create
        resources :designation_accounts, only: :create
        resources :designation_profiles, only: :create
        resources :donations, only: :create
        resources :donor_accounts, only: :create
        resource :query, only: :show
      end
    end
  end
end
