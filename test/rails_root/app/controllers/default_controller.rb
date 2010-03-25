class DefaultController < ApplicationController
  
  def index
    @user = User.first || User.create
    @user.blog ||= Blog.create(:title => 'test')
    @blog = @user.blog
  end
  
end