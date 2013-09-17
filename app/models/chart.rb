class Chart
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :config

  belongs_to :app

  validates_presence_of :name, :config, :app_id
end
