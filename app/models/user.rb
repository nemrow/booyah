class User < ActiveRecord::Base
  attr_accessible :cell, :email, :name, :password

  validates :email, :uniqueness => true
  validates :cell, :uniqueness => true

  has_secure_password

  has_many :addresses
  has_many :orders
  has_many :paypal_preapprovals

  before_create :format_cell

  def format_cell
    self.cell = 1.to_s + cell.gsub(/\D/,'').to_s
  end

  def preapproval
    paypal_preapprovals.where("active = true").first
  end

  def first_name
    name.match(/^[a-zA-Z]+/)[0]
  end

  def address
    addresses.first
  end

  def account_active?
    address && preapproval ? true : false
  end
end
