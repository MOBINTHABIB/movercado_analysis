class Interaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :app
  attr_accessible :name, :user_id, :app_id

  # Callbacks
  before_create :activity, :if => lambda { self.user.vendor?(self.app) }

  private
  def activity
  	interactions_count = self.user.interactions.where("created_at >= ?", Date.today.beginning_of_month).count

  	if interactions_count > 1000 # If the vendors interactions exceeded 1000 send an email
  		Notifier.suspicious_activity.deliver
  		raise ActiveRecord::Rollback # Prevent the record from being saved
  	end
  end
end
