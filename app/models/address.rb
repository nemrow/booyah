class Address < ActiveRecord::Base
  attr_accessible :address_line1, :address_line2, :city, :country, :state, :user_id, :zip, :primary, :lob_address_id

  belongs_to :user
end
