# == Schema Information
#
# Table name: users
#
#  id                  :integer         not null, primary key
#  login               :string(255)
#  email               :string(255)
#  first_name          :string(255)
#  last_name           :string(255)
#  crypted_password    :string(255)
#  password_salt       :string(255)
#  persistence_token   :string(255)
#  single_access_token :string(255)
#  perishable_token    :string(255)
#  login_count         :integer         default(0), not null
#  failed_login_count  :integer         default(0), not null
#  last_request_at     :datetime
#  last_login_at       :datetime
#  current_login_at    :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#  terms_of_service    :boolean         not null
#  time_zone           :string(255)     default("UTC")
#  disabled_at         :datetime
#  activated_at        :datetime
#  created_at          :datetime
#  updated_at          :datetime
#  comment_count       :integer         default(0)
#

require File.dirname(__FILE__) + '/../spec_helper'

# Use to test include MuckBlogs::Models::MuckBloggable
describe User do

  describe "A class that is blogable" do
    should_have_one :blog
    it "should automatically create a blog for the user" do
      lambda {
        @user = Factory(:user)
      }.should change(Blog, :count).by(1)
    end
  end

end
