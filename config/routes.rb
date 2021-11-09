# frozen_string_literal: true

Rails.application.routes.draw do
  root 'sessions#new'
  get '/main' => 'marks#main'
end
