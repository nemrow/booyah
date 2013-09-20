class Address < ActiveRecord::Base
  attr_accessible :address_line1, :address_line2, :city, :country, 
                  :state, :user_id, :zip, :default, :lob_address_id, :keyword, :name

  belongs_to :user
  before_save :deactivate_other_defaults, :downcase_fields

  def update_lob_friendly_attributes(address_params)
    update_attributes( 
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
end
