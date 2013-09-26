class CreditsController < ApplicationController
  before_filter :admin_credentials_required

  def create
    user = User.find(params[:user_id])
    if user.make_credit_transaction(params[:credit][:amount], params[:credit][:description])
      redirect_to admin_user_path(user, :notice => "Credits Updated")
    else
      redirect_to admin_user_path(user, :basic_error => "could not add credits")
    end
  end
end
