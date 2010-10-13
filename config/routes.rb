Rails.application.routes.draw do
  resources :posts, :controller => 'muck/posts'
  resources :blogs, :controller => 'muck/blogs' do
    resources :posts, :controller => 'muck/posts'
  end
end