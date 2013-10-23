class AppEvent
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps

  belongs_to :app

  field :name
  field :value # unused?
  field :top_level, type: Boolean, default: true

  default_scope where(top_level: true)
end
