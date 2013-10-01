class AppEvent
  include Mongoid::Document

  belongs_to :app

  field :name
end
