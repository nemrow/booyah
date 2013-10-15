include ApplicationHelper
require 'net/http'
require 'uri'
require 'csv'

class User < ActiveRecord::Base
  attr_accessible :cell, :email, :name, :password, :role

  validates :email, :uniqueness => {:message => 'That email has already been taken'}, 
    :presence => {:message => "Email is required"}
  validates_format_of :email, :with => /^[a-zA-Z0-9_.+\-]+@[a-zA-Z0-9\-]+\.[a-zA-Z0-9\-.]+$/, :message => "That is not a valid email" 
  validate :name_must_have_first_and_last
  validate :cell_must_be_numeric_only
  validates :cell, :uniqueness => {:message => "Someone has already taken that cell phone number"}, 
    :presence => {:message => "Cell phone number is required"}, 
    :length =>  {:is => 11, :message => "That is not a valid phone length"}

  has_secure_password

  has_many :addresses
  has_many :orders
  has_many :paypal_preapprovals
  has_many :credits

  before_validation :format_cell

  before_save :downcase_email

  def downcase_email
    self.email = self.email.downcase if email != nil
  end

  def cell_must_be_numeric_only
    if cell != nil
      fixed_cell = cell.gsub(/\(/,'').gsub(/\)/,'').gsub(/\s/,'').gsub(/-/,'')
      if fixed_cell.match(/\D/)
        errors.add(:cell, "Cell phone should only contain digits")
      end
    end
  end

  def self.get_all_non_active_users
    User.all.select { |user| !user.account_active? }
  end

  def self.get_all_active_users
    User.all.select { |user| user.account_active? }
  end

  def self.log_all_non_active_users
    list = get_all_non_active_users.map { |user| user.id }
    CSV.open("lib/assets/non_active_users_#{Time.now.to_s}.csv", "wb") { |csv| csv << list }
  end

  def self.log_all_active_users
    list = get_all_active_users.map { |user| user.id }
    CSV.open("lib/assets/active_users_#{Time.now.to_s}.csv", "wb") { |csv| csv << list }
  end

  def cell_form_formatted
    cell[1..cell.length]
  end

  def formatted_name
    name.split(' ').map{|name| name.capitalize}.join(' ')
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

  def default_address
    addresses.where(:default => true).first
  end

  def self.verify_status(params)
    user = find_by_cell(params['msisdn'])
    if user == nil
      User.send_sms({:cell => params['msisdn'], :message_code => 8})
      return false
    elsif !user.account_active?
      User.send_sms({:message_code => 7, :user => user, :cell => user.cell})
      return false
    end
    user   
  end

  def verify_receiver(params)
    receiver = get_receiver(params['message'])
    if receiver == 'people'
      User.send_sms({:message_code => 3, :user => self, :cell => self.cell})
      return false
    elsif !receiver
      User.send_sms({:message_code => 4, :user => self, :cell => cell})
      return false
    end
    receiver
  end

  def get_receiver(message)
    name = message.downcase.sub(/^#{ENV['MAIN_KEYWORD']}/, '')
    if name == nil || name == ''
      return default_address if default_address
      return false
    end
    return 'people' if name.strip == 'people'
    address_by_name = addresses.where(:name => name.strip).first
    return address_by_name if address_by_name
    address_by_keyword = addresses.where(:keyword => name.strip).first
    return address_by_keyword if address_by_keyword
    false 
  end

  def get_all_contacts
    addresses.map{|address| address.formatted_name}.join(', ')
  end

  def make_credit_transaction(amount, description)
    credit = Credit.create(
      :amount => amount,
      :description => description
    )
    credits << credit
  end

  def available_credits
    credits.sum('amount')
  end

  def format_cell
    if cell && cell != '' && cell.length != 11
      self.cell = 1.to_s + cell.gsub(/\D/,'').to_s
    end
  end

  def preapproval
    paypal_preapprovals.where("active = true").first
  end

  def first_name
    name.split(' ')[0].capitalize
  end

  def last_name
    name.split(' ')[1].capitalize
  end

  def address
    addresses.first
  end

  def account_active?
    address && preapproval ? true : false
  end

  def self.send_sms(params)
    url = URI.parse(
      "https://api.mogreet.com/moms/transaction.send?" +
      "client_id=4824" +
      "&token=8b229bb3e0a15ea0b5406ddc6d55be6f" +
      "&campaign_id=49137" +
      "&to=#{URI::encode(params[:cell])}" +
      "&message=#{URI::encode(message_code(params))}" +
      "&format=json"
    )
    User.make_mogreet_request(url)
  end

  def self.make_mogreet_request(url)
    response = Net::HTTP.start(url.host, use_ssl: true, ssl_version: 'SSLv3', verify_mode: OpenSSL::SSL::VERIFY_NONE) do |http|
      http.get url.request_uri
    end
  end

  def order_count
    orders.count
  end

  def self.message_code(params)
    case params[:message_code]
    when 1
      "Hello #{params[:order].user.first_name}, " +
      "your image has been received and it will be shipped to #{params[:receiver].formatted_name} shortly! " +
      "Order total: $#{params[:order].user_cost}."
    when 2
      "Hello #{params[:user].first_name}, " +
      "We are sorry, something went wrong and we could not complete your order!"
    when 3
      "Hello #{params[:user].first_name}, " +
      "Here is the list of contacts: #{params[:user].get_all_contacts}"
    when 4
      "Hello #{params[:user].first_name}, " +
      "We are sorry, we could not recognize the receiver for this picture! Reply with 'people' to get a list."
    when 5
      "Hello #{params[:order].user.first_name}, " +
      "your image has been received and it will be shipped to #{params[:receiver].formatted_name} shortly! " +
      "This print was free! There will be no charge."
    when 6
      "Hello #{params[:user].first_name}, " +
      "We are sorry, paypal will not allow us to complete your order. Please check your paypal account and contact us!"
    when 7
      "Hello #{params[:user].first_name}, " +
      "Your account is not active. Please go to pigeonpic.com to finish activating it!"
    when 8
      "Hello! This number is not registered with Pigeon. " +
      "Please go to pigeonpic.com to begin getting prints!"
    when 9
      "Hello #{params[:user].first_name}, " +
      "It appears there was no image attached to that message!"
    when 10
      "Hello #{params[:user].first_name}, welcome to Pigeon! " +
      "Send a picture along with 'fly' + 'recipient' to this number to place print orders!"
    when 11
      "Hello #{params[:user].first_name}, " +
      "Your temporary password is #{params[:password]}. Go to pigeonpic.com to change it. Thanks!"
    when 12
      "Hello #{params[:user].first_name}, " +
      "Something went wrong with the address of the recipient of this picture. Please contact us to resolve this."
    end
  end
end
