module MuckBlogsHelper
  
  def blog_posts(blog)
    posts = blog.posts.by_newest.paginate(:page => @page, :per_page => @per_page)
    render :partial => 'posts/posts', :locals => { :posts => posts }
  end
  
end