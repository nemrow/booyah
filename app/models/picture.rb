require 'RMagick' unless Rails.env.test?

class Picture < ActiveRecord::Base
  attr_accessible :jpg_source, :lob_object_id, :order_id, :pdf_source

  belongs_to :order

  @@lob = Lob(api_key: ENV['LOB_KEY'])

  def self.verify_image(params, user, message)
    if !params['images']
      User.send_sms({:user => user, :message_code => 9, :cell => user.cell})
      return false
    else
      image_hash = create_picture(params['images'][0]['image'], user, message)
      Picture.create(image_hash)
    end
  end

  def self.create_new_object(user, picture)
    if order = @@lob.objects.create("#{user.name}\'s Object", picture, 500)
      order
    else
      false
    end
  end

  def self.create_picture(file_url, user, message)
    file_name = create_file_name(user)
    img = Magick::Image::read(file_url).first
    if needs_rotation?(img)
      img = resize_image(img, 'portrait')
      img = write_message_if_exists('portrait', img, message)
      img = rotate_img(img)
    else
      img = resize_image(img, 'landscape')
      img = write_message_if_exists('landscape', img, message)
    end
    image_hash = {}
    image_hash[:pdf_source] = render_pdf(img, file_name, user)
    image_hash[:jpg_source] = render_jpg(img, file_name, user)
    image_hash
  end

  def self.write_message_if_exists(style, img, message)
    if message != '' && message != nil
      img = create_overlay(style, img)
      add_message(img, message)
    else
      img
    end
  end

  def self.resize_image(img, style)
    style == 'landscape' ? img.resize_to_fill(1800,1200) : img.resize_to_fill(1200,1800)
  end

  def self.create_overlay(style, img)
    background = Magick::Draw.new
    background.fill('black')
    background.opacity(0.7)
    background.stroke('transparent')
    # rectangle size: first two params are x and y of on end, last 2 params are x and y end points
    style == 'portrait' ? background.rectangle(0,1680,1200,1800) : background.rectangle(0,1080,1800,1200)
    background.draw(img)
    img
  end

  def self.add_message(img, message)
    message_text = Magick::Draw.new
    message_text.stroke('transparent')
    message_text.fill('white')
    message_text.pointsize('40')
    message_text.gravity = Magick::SouthGravity
    message_text.font_family = "helvetica"
    message_text.font_weight = Magick::BoldWeight
    message_text.font_style  = Magick::NormalStyle
    message_text.text(x = 0, y = 50, text = message)
    message_text.draw(img)
    img
  end

  def self.create_file_name(user)
    "user_#{user.id}_#{Time.now.to_i}"
  end

  def self.needs_rotation?(img)
    img.columns < img.rows ? true : false
  end

  def self.rotate_img(img)
    img.rotate(90)
  end

  def self.aws_path
    ENV['AWS_BUCKET_PATH']
  end

  def self.aws_users_path
    ENV['PAYPAL_MODE'] == 'sandbox' ? 'test_users_photos' : 'users_photos'
  end

  def self.aws_full_path_creator(user, file_name, extension)
    p "#{aws_path}/#{aws_users_path}/user_#{user.id}/#{file_name}.#{extension}"
    "#{aws_path}/#{aws_users_path}/user_#{user.id}/#{file_name}.#{extension}"
  end

  def self.render_jpg(img, file_name, user)
    img.density = "72x72"
    img.resize_to_fill(432,288).write("tmp/#{file_name}.jpg")
    write_to_aws(user, "#{file_name}.jpg")
    aws_full_path_creator(user, file_name, 'jpg')
  end

  def self.render_pdf(img, file_name, user)
    img.density = "300x300"
    img.write("tmp/#{file_name}.pdf")
    write_to_aws(user, "#{file_name}.pdf")
    aws_full_path_creator(user, file_name, 'pdf')
  end

  def self.write_to_aws(user, file_name)
    s3 = AWS::S3.new(
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
    )
    s3.buckets['pigeonpictures'].objects["#{aws_users_path}/user_#{user.id}/#{file_name}"].write( 
      :file => "tmp/#{file_name}",
      :acl => :public_read
    )
  end
end
