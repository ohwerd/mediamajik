Rails.application.routes.draw do
  get 'welcome_pages/welcome'

  resources :effects

  resources :users

  resources :galleries

  resources :images

  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'images#index'

  # Routes for additing and removing images from galleries
  post 'galleries/:id/add-image/:image_id' => 'galleries#add', as: :add_to_gallery
  post 'galleries/:id/remove-image/:image_id' => 'galleries#remove', as: :remove_from_gallery
  get 'image/galleries/:image_id' => 'galleries#select', as: :galleries_selection
  
  # Routes for appling effects to images
  get 'effect/images/:effect_id' => 'images#select', as: :images_selection
  post 'effects/:effect_id/apply-effect/:id' => 'images#apply_effect', as: :apply_effect

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

  resources :users do
    resources :galleries
    resources :images
  end

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
