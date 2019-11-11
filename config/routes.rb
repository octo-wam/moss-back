Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1, defaults: { content_type: "application/json", format: :json } do
      resources :questions, only: %i[index] do
        member do
          resources :votes, only: %i[index create]
          put 'votes', to: 'votes#update'
        end
      end

      get 'me', to: 'users#me'

      match '*path', to: 'api#not_found', via: :all
    end
  end

  get '/auth/google_oauth2/callback', to: 'google_oauth_callback#callback'

  match '*path', to: 'application#not_found', via: :all
end
