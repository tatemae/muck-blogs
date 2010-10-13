# include MuckBlogs::Models::MuckBloggable
module MuckBlogs
  module Models
    module MuckBloggable
      extend ActiveSupport::Concern
    
      included do
        has_one :blog, :as => :blogable, :dependent => :destroy
      end

      def after_create
        # setup a temp title using information from the parent.
        title = self.title rescue nil
        title ||= self.name rescue nil
        title ||= self.class.to_s
        title = I18n.t('muck.blogs.blog_title', :title => title)
        self.blog = Blog.create(:title => title)
      end
      
    end
  end
end
