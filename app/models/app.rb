class App
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name

  belongs_to :user
  has_many :charts
end
