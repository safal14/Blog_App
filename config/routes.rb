Rails.application.routes.draw do
  get "posts/index"
  get "posts/show"
  get "posts/new"
  get "posts/create"
  get "posts/edit"
  get "posts/update"
  get "posts/destroy"
  devise_for :users
  root "posts#index"
  resources :posts
  devise_scope :user do
    # Logged-out users see sign-up form at root
    unauthenticated do
      root to: "devise/registrations#new", as: :unauthenticated_root
    end
  namespace :admin do
    resources :users, only: [:index, :new, :create, :edit, :update, :destroy] do
      member do
        post :activate
        post :deactivate
      end
    end

    root to: "users#index"          # so /admin shows the users list
  end
    # Logged-in users see your home#index (or whatever you want)
    authenticated do
      root to: "home#index", as: :authenticated_root
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
# root to: "home#index"
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
