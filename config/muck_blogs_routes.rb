ActionController::Routing::Routes.draw do |map|
  map.resources :posts, :controller => 'muck/posts'
  map.resources :blogs, :controller => 'muck/blogs', :has_many => [:posts]
end
