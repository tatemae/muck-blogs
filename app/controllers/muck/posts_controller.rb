class Muck::PostsController < Muck::ContentsController
  unloadable

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
      @parent = get_parent
      if @parent && !@parent.is_a?(Blog)
        @blog = @parent.blog
        @blog ||= Blog.find(params[:id], :scope => Blog.blogable_to_scope(@parent))
      else
        @blog = @parent # parent found the blog
      end
      @blog ||= Blog.find(params[:id], :scope => MuckContents::GLOBAL_SCOPE) rescue nil
      @blog ||= Blog.first
    end
    
    def has_permission_to_add_content(user, parent, content)
      return true if parent.can_add_content?(user)
      super
    end
    
end