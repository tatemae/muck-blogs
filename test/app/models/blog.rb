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

class Blog < ActiveRecord::Base
  include MuckBlogs::Models::MuckBlog
end
