Rails.application.routes.draw do
  devise_for :users
  namespace :api, defaults: { format: :json } do
    resources :items, except: %I[new edit]
  end

  root 'items#index'
end
