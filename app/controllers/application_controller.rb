class ApplicationController < ActionController::Base
  protect_from_forgery
  include ApplicationHelper

  def require_login
    if !current_user
      redirect_to signin_path
    elsif User.find(params[:user_id]) != current_user
      redirect_to permission_denied_path
    end
  end

  def require_login_user
    user_id = params[:id] ? params[:id] : params[:user_id]
    if !current_user
      redirect_to signin_path
    elsif User.find(user_id) != current_user
      redirect_to permission_denied_path
    end
  end

  def admin_credentials_required
    if !current_user
      redirect_to signin_path
    elsif current_user.role != 'admin'
      redirect_to permission_denied_path
    end
  end
end
