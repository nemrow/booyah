class AddressesController < ApplicationController
  def new
    @address = Address.new
    @notice = params[:notice] if params[:notice]
    @error = params[:error] if params[:error]
  end

  def create
    user = User.find(params[:user_id])
    address = Address.verify_and_create_address(params[:address], user)
    return redirect_to new_user_address_path(current_user, :error => 'That address does not exist') if !address
    if user.preapproval
      redirect_to user_path(user)
    else
      redirect_to PaypalPreapproval.get_preapproval_url(user)
    end
  end

  def edit
    @error = params[:error] if params[:error]
    @user = User.find(params[:user_id])
    @address = Address.find(params[:id])
  end

  def update
    user = User.find(params[:user_id])
    address = Address.find(params[:id])
    if Address.verify_and_update_address(address, params[:address], user)
      redirect_to user_path(current_user)
    else 
      redirect_to edit_user_address_path(current_user, params[:id], :error => 'That address does not exist')
    end
  end
end
