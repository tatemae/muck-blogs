require 'ostruct'

module MuckBlogs
  
  def self.configuration
    # In case the user doesn't setup a configure block we can always return default settings:
    @configuration ||= Configuration.new
  end
  
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    
    attr_accessor :sanitize_attributes        # This enables or disables acts as solr for profiles.
    attr_accessor :enable_post_activities     # Determine whether or not an activity will be added after a user contributes a post.  
                                              # This requires that the application be configured to use Muck Activities.
                                              # Note that to enable this functionality the content model will need to have.
    
    def initialize
      self.sanitize_attributes = true
      self.enable_post_activities = true
    end
    
  end
end