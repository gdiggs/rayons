Rayons::Application.routes.draw do
  devise_for :users

  devise_scope :user do
    get "login", to: "devise/sessions#new"
    get "logout", to: "devise/sessions#destroy"
  end

  namespace :api do
    resources :items, only: [:show] do
      collection do
        get "daily"
        get "random"
      end
    end
  end

  resources :items, except: [:new] do
    collection do
      get "discover"
      get "import"
      post "import"
      get "random"
      get "latest"
      get "/page/:page", action: :index

      resource :alexa, only: [], controller: "items/alexa" do
        post "random"
      end
    end
  end

  resources :stats, only: [:index] do
    collection do
      get "counts_by_day"
      get "time_machine"
      get "words_for_field"
    end
  end

  resources :tracks, only: [:index, :show] do
    collection do
      get "find"
    end
  end

  get "/stats/time_machine/:month/:day", to: "stats#time_machine"
  get "/mu-9306e982-5e21cfff-5e7a9bbe-e08bb3ce", to: "application#blitz"
  get "/opensearch.xml", to: "application#opensearch"
  get "/status", to: "application#status"

  authenticate :user do
    root to: "items#index", as: :authenticated_root
  end
  root to: redirect("/users/sign_in")
end
