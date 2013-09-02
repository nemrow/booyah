class AddressesController < ApplicationController
  def new
    @address = Address.new
  end

  def create
    if address = verify_and_create_address(params[:address])
      redirect_to user_path(current_user)
    else 
      redirect_to new_user_address_path(current_user, :error => 'That address does not exist')
    end
  end
end
