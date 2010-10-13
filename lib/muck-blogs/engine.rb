require 'muck-blogs'
require 'rails'

module MuckBlogs
  class Engine < ::Rails::Engine
    
    def muck_name
      'muck-blogs'
    end
    
    initializer 'muck-blogs.helpers' do
      ActiveSupport.on_load(:action_view) do
        include MuckBlogsHelper
      end
    end
    
  end
end