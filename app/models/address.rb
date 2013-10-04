class Address < ActiveRecord::Base
  attr_accessible :address_line1, :address_line2, :city, :country, 
                  :state, :user_id, :zip, :default, :lob_address_id, :keyword, :name

  belongs_to :user
  has_many :orders

  validates :address_line1, :presence => {:message => "Address is required"}
  validates :city, :presence => {:message => "City is required"}
  validates :state, :presence => {:message => "State is required"}
  validates :zip, :presence => {:message => "Zip is required"}
  validates :name, :presence => {:message => "Name is required"}

  before_save :deactivate_other_defaults, :downcase_fields, :create_lob_address

  @@lob = Lob(api_key: ENV['LOB_KEY'])


  def create_lob_address
    self.lob_address_id = @@lob.addresses.create(Hash[self.attributes.map{|k,v| [k.to_sym , v]}])['id'] if address_changed?
  end

  def address_changed?
    address_line1_changed? || address_line2_changed? || city_changed? || 
    state_changed? || zip_changed? || country_changed? || name_changed?
  end

  def downcase_fields
    self.keyword = keyword.downcase if keyword
    self.name = name.downcase if name
  end

  def formatted_name
    name.split(' ').map{|name| name.capitalize}.join(' ')
  end

  def deactivate_other_defaults
    if self.default == true
      user.addresses.each{|address| address.update_attributes(:default => false) unless address.id == self.id}
    end
  end
end
