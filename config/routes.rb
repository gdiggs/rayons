Rayons::Application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"
  devise_for :users

  devise_scope :user do
    get "login", to: "devise/sessions#new"
    get "logout", to: "devise/sessions#destroy"
  end

  resources :items, except: [:new] do
    collection do
      get "daily"
      get "discover"
      post "import"
      post "import_discogs"
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
  root to: "items#index"
end
