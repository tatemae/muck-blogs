ActionController::Routing::Routes.draw do |map|
  
  map.home '', :controller => 'default', :action => 'index'
  map.root :controller => 'default', :action => 'index'
  
  map.root :controller => 'default', :action => 'index'
  map.resources :users do |users|
    users.resources :posts, :controller => 'muck/posts'
    users.resource :blog, :controller => 'muck/blogs' do |blog|
      blog.resources :posts, :controller => 'muck/posts'
    end
  end
  
end

