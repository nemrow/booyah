class Address < ActiveRecord::Base
  attr_accessible :address_line1, :address_line2, :city, :country, :state, :user_id, :zip, :default, :lob_address_id

  belongs_to :user

  def update_lob_friendly_attributes(address_params)
     update_attributes( :address_line1 => address_params[:address_line1],
                        :address_line2 => address_params[:address_line2],
                        :city => address_params[:address_city],
                        :state => address_params[:address_state],
                        :zip => address_params[:address_zip],
                        :country => address_params[:address_country],
                        :lob_address_id => address_params[:lob_address_id]
                      )
  end
end
