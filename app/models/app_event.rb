class AppEvent
  include Mongoid::Document

  belongs_to :app

  field :name
  field :value
  field :top_level, type: Boolean, default: true
end
