class Muck::PostsController < Muck::ContentsController
  unloadable

  skip_before_filter :setup_parent
  before_filter :setup_blog
  
  def index
    @posts = @blog.posts.by_newest
    respond_to do |format|
      format.html { render :template => 'posts/index', :layout => 'popup' }
      format.pjs { render :template => 'posts/index', :layout => false }
      format.rss { render :template => 'posts/index' }
    end
  end

  def show
    @content = Content.find(params[:id], :scope => Content.contentable_to_scope(@blog)) if @blog
    @content ||= Content.find(params[:id])
    super
  end
  
  def new
    @content = @blog.posts.new()
    respond_to do |format|
      format.html { render :template => 'posts/new' }
      format.pjs { render :template => 'posts/new', :layout => 'popup'}
    end
  end
  
  protected

    def setup_blog
      @parent = get_parent(:ignore => ['blog']) rescue nil
      if @parent && @parent.defined?(blog)
        @blog = @parent.blog # Found a blog that belongs to a parent object
      else
        # No blog was found. Try looking for a root blog in the url
        @blog = get_parent(:scope => Blog.blogable_to_scope)
      end
      @blog ||= Blog.first
      @parent ||= @blog
    end
    
    def has_permission_to_add_content(user, parent, content)
      return true if parent.can_add_content?(user)
      super
    end
    
end