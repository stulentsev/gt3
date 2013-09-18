class RawEntry
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :app

  field :event_params, type: Hash
end
