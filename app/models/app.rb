class App
  include Mongoid::Document
  include Mongoid::Timestamps

  field :_id, type: String, default: -> { Moped::BSON::ObjectId.new.to_s }

  field :name
  field :app_key

  validates_presence_of :name, :app_key

  after_initialize :generate_app_key

  belongs_to :user
  has_many :charts
  has_many :app_events

  private
  def generate_app_key
    self.app_key ||= SecureRandom.hex(10)
  end
end
