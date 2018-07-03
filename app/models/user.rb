class User < ApplicationRecord
  before_save :default_values
  
  ROLES = %i[admin manager user]  
  
  has_secure_password
  
  validates :password, :password_confirmation, presence: true, length: { minimum: 6 }, on: :create
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  
  has_many :jogs
  
  def default_values
    self.role = 'user' if self.role.nil?
  end  
  
  def as_json(options = {})
    super(options.merge({ except: [:password_digest] }))
  end  
    
end
