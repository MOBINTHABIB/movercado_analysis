class User < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :roles
  has_many :interactions
  has_many :codes
  has_many :phones

  attr_accessible :roles_attributes, :phones_attributes

  accepts_nested_attributes_for :roles, :phones

  # Scopes
  scope :activistas, joins(:roles).where("roles.name = 'activista'") # Returns all activistas
  scope :vendors, joins(:roles).where("roles.name = 'vendor'") # Returns all activistas

  def default_phone
    (phones.blank?) ? Phone.create(number: SecureRandom.hex) : phones.first
  end

  def interacted?(app)
    self.interactions.where(app_id: app.id).present?
  end

  def vendor?(app)
    has_role?(app, "vendor")
  end

  def activista?(app)
    has_role?(app, "activista")
  end

  def has_role?(app, role_name)
    self.roles.where(app_id: app.id, name: role_name).present?
  end

  def to_s
    "#{self.id}"
  end

  def self.top_activistas(week=Date.today.beginning_of_week)
    activistas_interactions = self.activistas.joins(:interactions).group("users.id").where("interactions.created_at" => week..week.end_of_week).count
    Hash[activistas_interactions.sort_by { |user_id, interactions_count| interactions_count }.reverse[0..9]]
  end

  def sessions_count_in(week=Date.today.beginning_of_week)
    self.interactions.where("interactions.created_at" => week..week.end_of_week).count
  end

  def first_session_in(week=Date.today.beginning_of_week)
    self.interactions.where("interactions.created_at" => week..week.end_of_week).order("created_at DESC").first
  end

  def last_session_in(week=Date.today.beginning_of_week)
    self.interactions.where("interactions.created_at" => week..week.end_of_week).order("created_at ASC").first
  end
end
