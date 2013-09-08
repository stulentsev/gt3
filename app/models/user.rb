class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  has_secure_password

  validates_presence_of :email, :name
  validates_presence_of :password, :on => :create

  field :name
  field :email
  field :password_digest


  has_many :apps
end
