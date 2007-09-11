ActionController::Routing::Routes.draw do |map|
  map.resources :users
  map.resource  :session
  
  map.dashboard 'd/:action', :controller => 'dashboard'
  
  map.resources :games
  map.resources :people
  
  map.activate 'activate/:activation_code', :controller => 'users', :action => 'activate'
  map.login 'login', :controller => 'sessions', :action => 'new'
  map.logout 'logout', :controller => 'sessions', :action => 'destroy'
  
  map.home '', :controller => 'dashboard', :action => 'index'
end