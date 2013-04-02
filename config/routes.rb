ProjectPortal::Application.routes.draw do
  resources :projects, :issues

  get "home/index"
  
  devise_for :users, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout'}

  match 'projects/:proj_id/createIssue' => 'issues#new', :as => :create_issue
  match 'projects/:proj_id/issues' => 'issues#index'
  match 'issues/:id/resolve' => 'issues#resolve', :as => :resolve_issue
  match 'issues/:id/accept' => 'issues#accept', :as => :accept_issue
  match 'issues/:id/deny' => 'issues#deny', :as => :deny_issue

  match 'projects/:id/user_edit' => 'projects#user_edit', :as => :user_edit_project
  get "user/show"
  match 'dashboard' => 'user#show', :as => :dashboard
  get "projects/show_all"
  match 'browse' => 'projects#show_all', :as => :browse

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
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
