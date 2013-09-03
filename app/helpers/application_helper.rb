require 'securerandom'
require 'RMagick'

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

  def create_picture(file_url, user)
    create_dir_if_none(user)
    file_path = create_file_path(user)
    img = Magick::Image::read(file_url).first
    img.density = "300x300"
    img.resize_to_fill(1800,1200).write("app/assets/images/#{file_path}")
    p "#{base_url}/assets/#{file_path}"
    "#{base_url}/assets/#{file_path}"
  end

  def create_file_path(user)
    "user_pictures/" +
    "id_#{user.id}/" +
    "#{Time.now.to_i}_#{SecureRandom.urlsafe_base64}.pdf"
  end

  def create_dir_if_none(user)
    dir = "app/assets/images/user_pictures/id_#{user.id}" 
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
  end
end
