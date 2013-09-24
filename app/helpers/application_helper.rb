require 'securerandom'

module ApplicationHelper
  include MessageHelper
  include EmailHelper
  
  def current_user
    begin
      User.find(session[:user_id]) if session[:user_id]
    rescue
      session[:user_id] = nil
      false
    end
  end

  def set_current_user(user)
    session[:user_id] = user.id
  end

  def remove_current_user
    session[:user_id] = nil
  end
end
