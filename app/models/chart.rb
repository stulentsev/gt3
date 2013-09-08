class Chart
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :config

  belongs_to :app
end
