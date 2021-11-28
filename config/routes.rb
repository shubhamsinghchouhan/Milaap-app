# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'loan_applications#dashboard'
  resources :loan_applications, only: %w[dashboard index new create show]
end
