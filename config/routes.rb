Rails.application.routes.draw do
  root to: "home#index"

  # users
  post '/users',   to: 'users#create', as: :user_registration

  # oauth doorkeeper
  use_doorkeeper do
    skip_controllers :authorizations, :applications, :authorized_applications

    controllers :tokens => 'custom_tokens'
  end

  # devise
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords: 'users/passwords'
  }

  namespace :api do
    namespace :v1 do

      # action_cable websocket
      mount ActionCable.server => '/cable'

      # users
      resources :users, only: [:index, :show, :create, :update, :destroy] do
        collection do
          get 'me'
        end
      end
      post '/users/:id/send_user_confirmation', to: 'users#send_user_confirmation', as: :send_user_confirmation
      post '/users/:id/update_password', to: 'users#update_password', as: :update_password
      post '/users/:id/confirm_user', to: 'users#confirm_user', as: :confirm_user
      post '/show_me', to: 'users#show_me', as: :show_me
      get '/users_list', to: 'users#list', as: :users_list
      get '/others', to: 'users#list_others', as: :list_others
      get '/new_others', to: 'users#list_new_others', as: :list_new_others

      # roles
      resources :roles, only: [:index, :show, :create, :update, :destroy]

      # user_roles
      post '/add_role_to_user', to: 'roles#add_role_to_user', as: :add_role_to_user
      delete '/delete_role_from_user', to: 'roles#delete_role_from_user', as: :delete_role_from_user

      # role_permissions
      resources :role_permissions, only: [:index, :show, :create, :update, :destroy]

      # permissions
      resources :permissions, only: [:index, :show, :create, :update, :destroy]
      get '/permissions_subject_list', to: 'permissions#permissions_subject_list', as: :permissions_subject_list

      # meter
      resources :meters, only: [] do
        get 'consumption'
      end
    end
  end
end
