# == Schema Information
#
# Table name: blogs
#
#  id            :integer         not null, primary key
#  blogable_id   :integer         default(0)
#  blogable_type :string(255)     default("")
#  title         :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

require File.dirname(__FILE__) + '/../test_helper'

class BlogTest < ActiveSupport::TestCase
  
  context "Blog" do
    setup do
      @user = Factory(:user)
      @blog = @user.blog
    end
    
    subject { @blog }
     
    should_validate_presence_of :title
    should_belong_to :blogable
    
    should_have_named_scope :by_newest
    should_have_named_scope :by_oldest
    should_have_named_scope :recent
    
    should "require title" do
      u = Factory.build(:blog, :title => nil)
      assert !u.valid?
      assert u.errors.on(:title)
    end
    should "be able to add content" do
      assert @blog.can_add_content?(@user)
    end
  end

end
