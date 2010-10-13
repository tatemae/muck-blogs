#include MuckBlogs::Models::MuckBlog
module MuckBlogs
  module Models
    module MuckBlog
      extend ActiveSupport::Concern
    
      included do
        
        has_many :posts, :as => :contentable, :class_name => 'Content'
        belongs_to :blogable, :polymorphic => true

        has_friendly_id :title, :use_slug => true, :scope => :get_blog_scope
        
        validates_presence_of :title
        
        scope :by_newest, :order => "created_at DESC"
        scope :by_oldest, :order => "created_at ASC"
        scope :newer_than, lambda { |*args| where("created_at > ?", args.first || DateTime.now) }
          
        before_save :sanitize_attributes if MuckBlogs.configuration.sanitize_content
                            
        attr_protected :created_at, :updated_at
      end

      module ClassMethods
        
        def blogable_to_scope(obj = nil)
          return MuckContents::GLOBAL_SCOPE if obj.blank?
          File.join('/', obj.class.to_s.tableize, obj.to_param)
        end
        
      end
      
      # Setup the scope for this content object
      def get_blog_scope
        if self.blogable_id > 0 && !self.blogable_type.blank?
          self.class.blogable_to_scope(self.blogable)
        else
          MuckBlogs::GLOBAL_SCOPE
        end
      end
      
      # Determines whether or not the given user has the right to add content to the blog
      # Override this method to change permissions.
      # Currently this method looks to the parent object and calls 'can_edit?' to determine
      # whether or not the user can edit the content
      def can_add_content?(user)
        if self.blogable_id > 0 && !self.blogable_type.blank?
          self.blogable.can_edit?(user)
        else
          # Global blog only let admin's access
          return true if user.admin?
        end
      end

      # Set the user who is currently editing the content.  This is used
      # to determine permissions
      def current_editor=(editor)
        @current_editor = editor
      end
      
      # Get the user that is currently editing the content
      def current_editor
        @current_editor
      end
      
      # Sanitize content before saving.  This prevent XSS attacks and other malicious html.
      def sanitize_attributes
        if self.sanitize_level
          self.description = Sanitize.clean(self.description, self.sanitize_level) unless self.description.nil?
          self.title = Sanitize.clean(self.title, self.sanitize_level)
        end
      end
      
      # Override this method to control sanitization levels.
      # Currently a user who is an admin will not have their content sanitized.  A user
      # in any role 'editor', 'manager', or 'contributor' will be given the 'RELAXED' settings
      # while all other users will get 'BASIC'.
      #
      # By default the 'creator' of the content will be used to determine which level of
      # sanitization is allowed.  To change this set 'current_editor' before
      #
      # Options are from sanitze:
      # nil - no sanitize
      # Sanitize::Config::RELAXED
      # Sanitize::Config::BASIC
      # Sanitize::Config::RESTRICTED
      # for more details see: http://rgrove.github.com/sanitize/
      def sanitize_level
        return Sanitize::Config::BASIC if current_editor.nil?
        return nil if current_editor.admin?
        return Sanitize::Config::RELAXED if current_editor.any_role?('editor', 'manager', 'contributor')
        Sanitize::Config::BASIC
      end
      
    end
  end
end