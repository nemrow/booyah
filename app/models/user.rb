class User < ActiveRecord::Base
  attr_accessible :cell, :email, :first_name, :last_name, :password

  has_secure_password

  has_many :addresses
  has_many :orders

  def full_name
    "#{first_name} #{last_name}"
  end

  def address
    addresses.first
  end
end
