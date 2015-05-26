class TrackJob < ActiveJob::Base
  queue_as :track

  def perform(tid, cuid, url, action_name="click")
    History.create(item_id: tid, user_id: cuid, url: url, action_name: action_name)
  end
end
