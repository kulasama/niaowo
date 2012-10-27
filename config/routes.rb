Niaowo::Application.routes.draw do
  
  get "member/msg" 
  get "member/feeds"
  get "member/topics"
  get "member/comments"
  get "member/commenteds"
  get "member/ats"
  get "member/praises"
  
  get "files/:md5(.:subfix)" => "files#show"
  post "files" => "files#create"


  match "search" => "member#search"




  resource :praises 
  resources :tags do
    get 'page/:page', :action => :index, :on => :collection
  end
  
  resources :topics do
    get 'page/:page', :action => :index, :on => :collection
    resources :comments

  end
  
  post 'topics/:id/pei' => "topics#pei"
  post 'comments/:id/pei' => "comments#pei"

  resources :comments

  resources :invitations do
    get 'page/:page', :action => :index,:on=>:collection
  end

  


  devise_for :members, :path => "account", :controllers => {
      :registrations => :account,
      :omniauth_callbacks => "members/omniauth_callbacks"
  }  


  


  devise_scope :member do
    get "/account/sign_in" => "devise/sessions#new"
    get "/account/sign_out" => "devise/sessions#destroy" 
    post "/account/token" => "account#token"
    post '/account/sign_in' => 'devise/sessions#create'
  end






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
  root :to => 'topics#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
