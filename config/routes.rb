# frozen_string_literal: true

Rails.application.routes.draw do
  root 'sessions#new'
  get '/main' => 'marks#main'
  namespace :api, format: 'json' do
    resources :marks, only: %i[index create edit update destroy]
  end
end
