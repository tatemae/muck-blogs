class DefaultController < ApplicationController
  
  def index
    @user = User.first || User.create
    @user.blog ||= Blog.create(:title => 'test', :description => 'A test blog')
    @blog = @user.blog
  end
  
end