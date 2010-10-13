# include MuckBlogs::Models::MuckPost
module MuckBlogs
  module Models
    module MuckPost
      extend ActiveSupport::Concern
    
      included do
        belongs_to :blog, :dependent => :destroy        
      end
      
      def after_create
        if MuckBlogs.configuration.enable_post_activities
          
        end
      end

    end
  end
end
