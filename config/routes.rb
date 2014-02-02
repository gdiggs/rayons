Rayons::Application.routes.draw do
  devise_for :users

  devise_scope :user do
    get "login", :to => "devise/sessions#new"
    get "logout", :to => "devise/sessions#destroy"
  end

  resources :items do
    collection do
      post 'import'
      get 'random'
      get 'time_machine'
      get 'words_for_field'
      get 'counts_by_day'
      get 'latest'
    end
  end

  get '/mu-9306e982-5e21cfff-5e7a9bbe-e08bb3ce', :to => 'application#blitz'
  get '/stats', :to => 'items#stats'
  root :to => "items#index"
end
