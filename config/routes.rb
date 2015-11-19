Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  get '/account', to: 'welcome#account', as: 'account'

  get '/about', to: 'welcome#about', as: 'about'

  # ____ Omniauth and sessions ____
  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]

  match '/auth/failure', :to => 'sessions#failure', :via => [:get, :post]

  match '/logout', to: 'sessions#destroy', via: [:get, :post], as: "logout"

  put '/filter/:level', to: 'sessions#language_filter', as: "filter"


  # ____ BookDuets ____
  get '/suggested_pairing/:level' => 'book_duets#suggested_pairing', as: 'suggested_pairing'

  post '/custom_duet_redirect' => 'book_duets#custom_duet_redirect', as: 'custom_duet_redirect'

  get '/custom_duet/:musician/:author/:level' => 'book_duets#custom_duet', as: 'custom_duet', :constraints => { :musician => /[^\/]+/, :author => /[^\/]+/, }

  post '/book_duets/:id/add_to_mixtape', to: 'book_duets#add_to_mixtape', as: 'add_to_mixtape'

  post '/book_duets' => 'book_duets#create', as: 'create_book_duet'

  resources :book_duets, only: [:index, :show]

  # ____ Mixtapes ____
  delete '/mixtapes/:mixtape_id/book_duet/:id', to: 'mixtapes#remove_book_duet', as: 'remove_book_duet'
  resources :mixtapes

  resources :account_activations, only: [:edit]
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
