Rails.application.routes.draw do
  resources :questions do
    resources :answers, shallow: true do
      put 'approve', on: :member
      delete 'deny', on: :member
    end
    put 'approve', on: :member
  end


  devise_for :users
  resources :electives do
    resources :questions
  end
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "pages#home"

  get "/search", to: "search#search"
  get "/search_electives", to: "search#show"
  get "/wp_support", to: "pages#wp_support"
  get "/finances", to: "pages#finances"
  get "/faq", to: "pages#faq"
  get '/admin_dashboard', to: 'admin_dashboard#index', as: 'admin_dashboard'

end
