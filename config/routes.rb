ProjectPortal::Application.routes.draw do
  devise_for :organizations

  get 'search' => "projects#search", :as => :search
  devise_for :users, :path => '', :path_names =>
                                    {:sign_in => 'login', :sign_out => 'logout'},
               :controllers => { :registrations => 'UserRegistrations' }
  resources :questions

  resources :projects do
    member do
      put :edit_question
    end
    member do
      post :add_org
      post :remove_orgs
    end
    resources :issues
    collection do
      match 'org_questions'
    end
  end

  resources :email_notifications

  get "home/index"

  resources :project_steps

  get "user/show"
  get "user/settings"
  match "admin_dashboard" => 'user#admin_dashboard', :as => :admin_dashboard
  match 'dashboard' => 'user#dashboard', :as => :dashboard

  match 'delete_question/:id' => 'questions#destroy', :as => 'delete_question'

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

  match 'projects/org_questions' => 'projects#org_questions', :as => :project_questions

  # Adds separate URLs to sign up for client and developers. Removed for two-stage sign up process.

  devise_scope :user do
    match 'developer/sign_up' => 'user_registrations#temp',
          :user => { :user_type => 'developer' }
    match 'client/sign_up' => 'user_registrations#new',
          :user => { :user_type => 'client' }
  end


  resources :organizations do
    resources :projects, only: [:index]
  end


  root :to => 'home#index'

end
