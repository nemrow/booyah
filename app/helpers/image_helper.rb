require 'RMagick' unless Rails.env.test?

module ImageHelper
  def create_picture(file_url, user)
    file_name = create_file_name(user)
    img = Magick::Image::read(file_url).first
    img = rotate_img_if_needed(img)
    image_hash = {}
    image_hash[:pdf] = render_pdf(img, file_name, user)
    image_hash[:jpg] = render_jpg(img, file_name, user)
    p image_hash
    image_hash
  end

  def rotate_img_if_needed(img)
    img.columns < img.rows ? img.rotate(90) : img
  end

  def render_jpg(img, file_name, user)
    img.density = "72x72"
    img.resize_to_fill(432,288).write("tmp/#{file_name}.jpg")
    write_to_aws(user, "#{file_name}.jpg")
    "https://s3.amazonaws.com/booyahbooyah/#{file_name}.jpg"
  end

  def render_pdf(img, file_name, user)
    img.density = "300x300"
    img.resize_to_fill(1800,1200).write("tmp/#{file_name}.pdf")
    write_to_aws(user, "#{file_name}.pdf")
    "https://s3.amazonaws.com/booyahbooyah/#{file_name}.pdf"
  end

  def create_file_name(user)
    "user_#{user.id}_#{Time.now.to_i}"
  end

  def write_to_aws(user, file_name)
    s3 = AWS::S3.new(
                      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
                      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
                    )
    s3.buckets['booyahbooyah'].objects[file_name].write( :file => "tmp/#{file_name}",
                                                          :acl => :public_read
                                                        )
  end
end