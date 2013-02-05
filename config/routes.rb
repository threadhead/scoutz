Scoutz::Application.routes.draw do

  get "dashboard_list" => "dashboard_list#index"
  get "dashboard_calendar" => "dashboard_calendar#index"
  get "dashboard/index" => "dashboard_list#index"

  get "events/index"
  resources :events do
    collection do
      get 'calendar'
    end
  end

  resources :sub_units
  resources :organizations do
    resources :events
  end
  post 'organizations/new' => 'organizations#new'
  devise_for :users, controllers: {registrations: "registrations", sessions: 'sessions'}
  resources :users

  get "page/landing"
  get "page/terms_of_service"
  get "page/privacy"
  get "page/contact"
  get "page/about"

  get "sign_up/import"
  get "sign_up/user"
  post "sign_up/new_unit"
  post "sign_up/create_unit"
  get "sign_up/new_sub_unit"
  post "sign_up/create_sub_unit"

  # resources :after_signup

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'dashboard_list#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
