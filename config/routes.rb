# config/routes.rb
Rails.application.routes.draw do
  # This creates /forecast as the correct route
  get '/forecast', to: 'forecast#index'

  # Optional: make root path also show forecast
  root 'forecast#index'

  # Health check (already there)
  get "up" => "rails/health#show", as: :rails_health_check
end
