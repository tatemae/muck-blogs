# == Schema Information
#
# Table name: activities
#
#  id               :integer         not null, primary key
#  item_id          :integer
#  item_type        :string(255)
#  template         :string(255)
#  source_id        :integer
#  source_type      :string(255)
#  content          :text
#  title            :string(255)
#  is_status_update :boolean
#  is_public        :boolean         default(TRUE)
#  created_at       :datetime
#  updated_at       :datetime
#  comment_count    :integer         default(0)
#

class Activity < ActiveRecord::Base
  acts_as_muck_activity
end
