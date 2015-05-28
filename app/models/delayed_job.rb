# == Schema Information
#
# Table name: delayed_jobs
#
#  id         :integer          not null, primary key
#  priority   :integer          default("0"), not null
#  attempts   :integer          default("0"), not null
#  handler    :text             not null
#  last_error :text
#  run_at     :datetime
#  locked_at  :datetime
#  failed_at  :datetime
#  locked_by  :string
#  queue      :string
#  created_at :datetime
#  updated_at :datetime
#

class DelayedJob < ActiveRecord::Base
end
