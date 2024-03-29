ActionController::Routing::Routes.draw do |map|
  map.resources :companies

  map.resources :routes

  map.resources :orders

  map.resources :addresses

  map.resources :packages

  map.resources :employees

  map.resources :creditcards

  map.resources :clients

  map.resources :web_services

  map.code '/code', :controller => 'creditcards', :action => 'code'

  map.my_route '/my_route', :controller => 'routes', :action => 'my_route'

  map.index_support_request '/index_support_request', :controller => 'orders', :action => 'index_support_request'

  map.new_support_request '/new_support_request', :controller => 'orders', :action => 'new_support_request'

  map.simulation '/simulation',:controller => 'orders', :action =>'simulation'

  map.xml 'support_request' , :controller => 'web_service', :action => 'support_request', :via => 'post'

  map.xml 'track_id/:id' , :controller => 'web_service', :action => 'track_id', :via => 'get'

  map.xml 'pickup/:id' , :controller => 'orders', :action => 'pickup', :via => 'get'

  map.track '/track/:trackid' , :controller => 'orders', :action => 'track', :via=> 'get'

  map.simulate '/simulate/:id' , :controller => 'orders', :action => 'simulate', :via=> 'get'

  map.new_support_request '/new_support_request/:id' , :controller => 'orders', :action=> 'new_support_request', :via=> 'get'
  
  map.operations '/operations', :controller => 'operations'
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "home"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
