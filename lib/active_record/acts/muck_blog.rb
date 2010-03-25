module ActiveRecord
  module Acts #:nodoc:
    module MuckBlog #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        def acts_as_muck_blog(options = {})
          
          default_options = { 
            :sanitize_content => true,
          }
          options = default_options.merge(options)
        
          has_many :posts, :as => :contentable, :class_name => 'Content'
          belongs_to :blogable, :polymorphic => true

          has_friendly_id :title, :use_slug => true, :scope => :get_blog_scope
          
          validates_presence_of :title
          
          named_scope :by_newest, :order => "created_at DESC"
          named_scope :by_oldest, :order => "created_at ASC"
          named_scope :recent, lambda { { :conditions => ['created_at > ?', 1.week.ago] } }
          
          if options[:sanitize_content]
            before_save :sanitize_attributes
          end
                            
          class_eval <<-EOV
            # prevents a user from submitting a crafted form that changes audit values
            attr_protected :created_at, :updated_at
          EOV

          include ActiveRecord::Acts::MuckBlog::InstanceMethods
          extend ActiveRecord::Acts::MuckBlog::SingletonMethods
          
        end
      end

      # class methods
      module SingletonMethods
        def blogable_to_scope(obj)
          File.join('/', obj.class.to_s.tableize, obj.to_param)
        end
      end
      
      # All the methods available to a record that has had <tt>acts_as_muck_blog</tt> specified.
      module InstanceMethods

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
          blogable.can_edit?(user)
        end

        # Sanitize content before saving.  This prevent XSS attacks and other malicious html.
        def sanitize_attributes
          if self.sanitize_level
            self.description = Sanitize.clean(self.description, self.sanitize_level)
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
end
