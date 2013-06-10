ProjectPortal::Application.routes.draw do
  devise_for :organizations

  get 'search' => "projects#search", :as => :search
  devise_for :users, :path => '', :path_names =>
                                    {:sign_in => 'login', :sign_out => 'logout'},
               :controllers => { :registrations => 'UserRegistrations' }
  resources :questions

  resources :projects do
    resources :issues
    collection do
      post 'org_questions'
    end
  end

  resources :email_notifications

  resources :project_steps

  devise_for :users, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout'}


  get "user/show"
  get "user/settings"
  get "user/admin_dashboard"
  match 'dashboard' => 'user#dashboard', :as => :dashboard


  get "home/index"

  match 'issues' => 'issues#index', :as => :issues
  match 'issues/:id/resolve' => 'issues#resolve', :as => :resolve_issue
  match 'issues/:id/accept' => 'issues#accept', :as => :accept_issue
  match 'issues/:id/deny' => 'issues#deny', :as => :deny_issue

  match 'projects/:id/favorite' => 'projects#favorite', :as => :add_favorite
  match 'projects/:id/unfavorite' => 'projects#unfavorite', :as => :remove_favorite
  match 'projects/approval/:id' => 'projects#approval', :as => :approval
  match 'projects/public_edit/:id' => 'projects#public_edit', :as => :public_edit

  match 'admins/manage' => 'user#add_admin', :as => :add_admin
  match 'admins/remove/:id' => 'user#remove_admin', :as => :remove_admin

  match 'projects/:id/comment' => 'projects#comment', :as => :comment
  match 'projects/:id/delete_comment' => 'projects#delete_comment', :as => :delete_comment

  match 'volunteer_intro' => 'home#volunteer_intro'
  match 'organization_intro' => 'home#organization_intro'

  # Adds separate URLs to sign up for client and developers. Removed for two-stage sign up process.

  devise_scope :user do
    match 'developer/sign_up' => 'user_registrations#new',
          :user => { :user_type => 'developer' }
    match 'client/sign_up' => 'user_registrations#new',
          :user => { :user_type => 'client' }
  end

  # Adds separate URLs to sign up for client and developers. Removed for two-stage sign up process.
  # devise_scope :user do
  #   match 'client/sign_up' => 'user_registrations#new', :user => { :user_type => 'client' }
  #   match 'developer/sign_up' => 'user_registrations#new', :user => { :user_type => 'developer' }
  # end

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
