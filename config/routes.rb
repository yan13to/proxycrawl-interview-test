Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :items, except: %I[new edit]
  end

  root 'items#index'
end
