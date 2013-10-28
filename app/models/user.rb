class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  has_secure_password

  validates_presence_of :email, :name
  validates_presence_of :password, :on => :create

  before_save :init_api_key

  field :name
  field :email
  field :password_digest

  field :api_key
  field :ndays, type: Integer, default: 30


  has_many :apps

  private
  def init_api_key
    self.api_key ||= SecureRandom.hex
  end
end
