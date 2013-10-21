class AppEvent
  include Mongoid::Document

  belongs_to :app

  field :name
  field :value
  field :top_level, type: Boolean, default: true

  default_scope where(top_level: true)
end
