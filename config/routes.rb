Scoutz::Application.routes.draw do

  get 'user_passwords/edit'

  get 'user_passwords/update'

  mount Ckeditor::Engine => '/ckeditor'
  devise_for :users, controllers: {registrations: "registrations", sessions: 'sessions'}
  # get "events/index"

  # get "dashboard_list" => "dashboard_list#index"
  # get "dashboard_calendar" => "dashboard_calendar#index"
  # get "dashboard/index" => "dashboard_list#index"

  get "events/index"
  resources :events do
    resources :event_signups
    resources :email_event_signups
    member do
      get 'email_attendees'
      get 'sms_attendees'
    end
  end

  resources :sub_units
  resources :units do
    resources :events do
      collection do
        get 'calendar'
      end
    end
    resources :scouts
    resources :adults
    resources :email_messages
    resources :sms_messages
    resources :users
    resources :merit_badges
    resources :user_passwords
    collection do
      get 'change_default_unit'
    end
  end

  post 'units/new' => 'units#new'
  # resources :users
  # resources :scouts
  # resources :adults
  resources :event_signups

  get "page/landing"
  get "page/terms_of_service"
  get "page/privacy"
  get "page/contact"
  get "page/about"

  get "sign_up/import"
  get "sign_up/user"
  # post "sign_up/new_unit"
  get "sign_up/new_unit"
  post "sign_up/create_unit"
  get "sign_up/new_sub_unit"
  post "sign_up/create_sub_unit"

  put "sms/send_verification"
  # resources :after_signup

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'dashboard_list#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
