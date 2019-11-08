Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :questions, only: %i[index]

      match '*path', to: 'api#not_found', via: :all
    end
  end

  match '*path', to: 'application#not_found', via: :all
end
