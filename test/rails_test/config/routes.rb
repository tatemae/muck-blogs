RailsTest::Application.routes.draw do
  root :to => "default#index"
  resources :users do
    resources :posts, :controller => 'muck/posts'
    resource :blog, :controller => 'muck/blogs'
      resources :posts, :controller => 'muck/posts'
    end
  end
  
end

