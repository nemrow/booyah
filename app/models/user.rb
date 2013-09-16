class User < ActiveRecord::Base
  attr_accessible :cell, :email, :name, :password

  validates :email, :uniqueness => {:message => 'That email has already been taken'}, 
    :presence => {:message => "Email is required"}
  validates_format_of :email, :with => /^[a-zA-Z0-9_.+\-]+@[a-zA-Z0-9\-]+\.[a-zA-Z0-9\-.]+$/, :message => "That is not a valid email" 
  validate :name_must_have_first_and_last
  validate :cell_must_be_numeric_only
  validates :cell, :uniqueness => {:message => "Someone has already taken that cell phone number"}, 
    :presence => {:message => "Cell phone number is required"}, 
    :length =>  {:is => 14, :message => "That is not a valid phone length"}

  has_secure_password

  has_many :addresses
  has_many :orders
  has_many :paypal_preapprovals

  before_create :format_cell

  def cell_must_be_numeric_only
    if cell != nil
      fixed_cell = cell.gsub(/\(/,'').gsub(/\)/,'').gsub(/\s/,'').gsub(/-/,'')
      if fixed_cell.match(/\D/)
        errors.add(:cell, "Cell phone should only contain digits")
      end
    end
  end

  def name_must_have_first_and_last
    if name == nil
      errors.add(:name, "Name must be provided")      
    elsif name.split(' ').count < 2
      errors.add(:name, "Must provide first and last name")
    elsif name.split(' ').count > 2
      errors.add(:name, "Only first and last name are needed")
    end
  end

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
