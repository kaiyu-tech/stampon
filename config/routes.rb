# frozen_string_literal: true

Rails.application.routes.draw do
  root 'sessions#new'

  resources :marks, only: :index

  namespace :api, format: 'json' do
    resources :users, only: :destroy
    resources :marks, only: %i[index create edit update destroy]
  end
end
