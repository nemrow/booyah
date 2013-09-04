require 'securerandom'

module ApplicationHelper
  include OrdersHelper

  def base_url
    request.protocol + request.host_with_port
  end

  def environment
    if base_url == "http://localhost:3000"
      "local"
    elsif base_url == "http://test.host"
      "test"
    elsif base_url == "http://booyah-s.herokuapp.com"
      "staging"
    elsif base_url == 'http://booyah-p.herokuapp.com'
      "production"
    end
  end
  
  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  def set_current_user(user)
    session[:user_id] = user.id
  end

  def remove_current_user
    session[:user_id] = nil
  end
end
