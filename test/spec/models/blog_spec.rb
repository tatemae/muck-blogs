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

require File.dirname(__FILE__) + '/../spec_helper'

describe Blog do
  
  before do
    @user = Factory(:user)
    @blog = @user.blog
  end
   
  it { should validate_presence_of :title }
  it { should belong_to :blogable }
  
  it { should scope_by_newest }
  it { should scope_by_oldest }
  it { should scope_newer_than }
  
  it "should require title" do
    u = Factory.build(:blog, :title => nil)
    u.should_not be_valid
    u.errors[:title].should_not be_empty
  end
  it "should be able to add content" do
    @blog.can_add_content(@user).should be_true
  end
end