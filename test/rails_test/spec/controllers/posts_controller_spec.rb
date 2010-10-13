require File.dirname(__FILE__) + '/../spec_helper'

class Muck::PostsControllerTest < ActionController::TestCase

  tests Muck::PostsController

  describe "posts controller" do
    before do
      @user = Factory(:user)
      @blog = @user.blog
      @post = Factory(:content, :contentable => @blog)
      @post_too = Factory(:content, :contentable => @blog)
    end

    describe "GET index" do
      before do
        get :index
      end
      it { should_not set_the_flash }
      it { should respond_with :success }
      it { should render_template :index }
    end
    
    describe "GET new" do
      before do
        get :new
      end
      it { should_not set_the_flash }
      it { should respond_with :success }
      it { should render_template :index }
    end
    
    describe "GET show" do
      before do
        get :show, :id => @post.to_param, :blog_id => @blog.id
      end
      it { should_not set_the_flash }
      it { should respond_with :success }
      it { should render_template :show }
    end

    describe "nested" do
      describe "GET show with numeric post id" do
        before do
          get :show, :id => @post.id, :user_id => @user.to_param
        end
        it { should_not set_the_flash }
        it { should respond_with 301 } # will do a permanent redirect since we called show with a numeric id
      end
    
      describe "GET show" do
        before do
          get :show, :id => @post.to_param, :user_id => @user.to_param
        end
        it { should_not set_the_flash }
        it { should respond_with :success }
        it { should render_template :show }
      end
      
      describe "GET new" do
        before do
          get :new, :user_id => @user.to_param
        end
        it { should_not set_the_flash }
        it { should respond_with :success }
        it { should render_template :new }
      end
    end
    
    describe "parent object in url" do
      describe "GET show using parent and blog" do
        before do
          get :show, make_parent_params(@user).merge(:id => @post.to_param)
        end
        it { should_not set_the_flash }
        it { should respond_with :success }
        it { should render_template :show }
      end
    
      describe "GET index using user as parent object" do
        before do
          get :index, make_parent_params(@user)
        end
        it { should_not set_the_flash }
        it { should respond_with :success }
        it { should render_template :index }
      end
    end
    
    describe "GET index using user_id" do
      before do
        get :index, :user_id => @user.to_param
      end
      it { should_not set_the_flash }
      it { should respond_with :success }
      it { should render_template :index }
    end
    
  end
  
end
