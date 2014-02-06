Finplan::Application.routes.draw do
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
 resources :plans do
   member do
     get :reload
   end

   collection do
   end
 end
 
resources :plan_users do
   member do
   end

   collection do
   end
 end
 
 resources :expenses do
   member do
   end
 end
 
 resources :goals do
   member do
     get :show_results
   end
   collection do     
   end
 end
 
 resources :accounts do
   member do
   end

   collection do
   end
 end
 
 resources :users do
   member do
   end

   collection do
     post :login
   end
 end
 
 resources :manipulator_templates do
   member do
   end

   collection do
   end
 end
 
 resources :variable_properties do
   member do
   end

   collection do
   end
 end
 
 resources :manipulators do
   member do
   end

   collection do
     get :goals
   end
 end

 resources :tax_rate_schedules do
   member do
   end

   collection do
   end
 end

 resources :tax_brackets do
   member do
   end

   collection do
   end
 end

 resources :welcome do

 end

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
  root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
