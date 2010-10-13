require File.dirname(__FILE__) + '/../spec_helper'

class Muck::BlogsControllerTest < ActionController::TestCase

  tests Muck::BlogsController

  describe "blogs controller" do
    before do
      @user = Factory(:user)
      @blog = @user.blog
    end
    
    describe "GET show" do
      before do
        get :show, :id => @blog.id
      end
      it { should redirect_to( blog_posts_path(@blog) ) }
    end

    describe "GET show using parent" do
      before do
        get :show, make_parent_params(@user).merge(:id => @blog.to_param)
      end
      it { should redirect_to( user_blog_posts_path(@user) ) }
    end
    
    describe "GET index" do
      before do
        # create a few blogs to be displayed
        Factory(:blog)
        Factory(:blog)
        get :index
      end
      it { should_not set_the_flash }
      it { should respond_with :success }
      it { should render_template :index }
    end
    
    describe "GET index when user only has one blog" do
      before do
        get :index, make_parent_params(@user)
      end
      it { should redirect_to( user_blog_posts_path(@user) ) }
    end
    
  end
  
end
