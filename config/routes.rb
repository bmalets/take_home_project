Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "file_imports#index"

  resources :file_imports, only: [:destroy] do
    resources :trade_lines, only: [:index]
    resource :summary, only: [:show]
  end
end
