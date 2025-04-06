Rails.application.routes.draw do
  root "forecasts#new"
  resources :forecasts, only: [:new, :create]
end
