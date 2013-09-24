class Address < ActiveRecord::Base
  attr_accessible :address_line1, :address_line2, :city, :country, 
                  :state, :user_id, :zip, :default, :lob_address_id, :keyword, :name

  belongs_to :user
  before_save :deactivate_other_defaults, :downcase_fields

  @@lob = Lob(api_key: ENV['LOB_KEY'])

  def update_lob_friendly_attributes(address_params)
      self.update_attributes( 
      :address_line1 => address_params[:address_line1],
      :address_line2 => address_params[:address_line2],
      :city => address_params[:address_city],
      :state => address_params[:address_state],
      :zip => address_params[:address_zip],
      :country => address_params[:address_country],
      :lob_address_id => address_params[:lob_address_id],
      :keyword => address_params[:keyword],
      :name => address_params[:name],
      :default => address_params[:default]
    )
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

  def self.create_new_address(address_params, user)
    new_address = Address.new(address_params)
    user.addresses << new_address
    address_params.merge!(  
      :email => user.email,
      :phone => user.cell
    )
    new_lob_address = @@lob.addresses.create(address_params)
    new_address.lob_address_id = new_lob_address['id']
    new_address.save
    new_lob_address
  end

  def self.update_address(address_params, address, user)
    address_params.merge!(  
      :email => user.email,
      :phone => user.cell
    )
    new_lob_address = @@lob.addresses.create(address_params)
    address_params.merge!(:lob_address_id => new_lob_address['id'])
    address.update_lob_friendly_attributes(address_params)
    new_lob_address
  end

  def self.verify_and_create_address(address_params, user)
    begin
      verify_address_via_lob(address_params.except(:keyword, :default, :name).dup)
      Address.create_new_address(address_params, user)
    rescue Exception => e
      false
    end
  end

  def self.verify_address_via_lob(address_params)
    @@lob.addresses.verify(address_params.dup)
  end

  def self.verify_and_update_address(address, address_params, user)
    begin
      verify_address_via_lob(address_params.except(:keyword, :default, :name).dup)
      update_address(address_params, address, user)
    rescue
      false
    end
  end
end
