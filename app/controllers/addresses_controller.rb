class AddressesController < ApplicationController
  before_filter :require_login

  def new
    @address = Address.new
    @notice = params[:notice] if params[:notice]
    @error = format_errors(params[:error]) if params[:error]
  end

  def create
    user = User.find(params[:user_id])
    address = Address.new(params[:address])
    return redirect_to new_user_address_path(user, :error => address.errors.messages) if !address.save
    user.addresses << address
    if user.preapproval
      redirect_to user_path(user)
    else
      redirect_to PaypalPreapproval.get_preapproval_url(user)
    end
  end

  def edit
    @error = format_errors(params[:error]) if params[:error]
    @user = User.find(params[:user_id])
    @address = Address.find(params[:id])
  end

  def update
    user = User.find(params[:user_id])
    address = Address.find(params[:id])
    if address.update_attributes(params[:address])
      redirect_to user_path(user)
    else
      redirect_to edit_user_address_path(current_user, params[:id], :error => address.errors.messages)
    end
  end
end
