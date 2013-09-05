require 'RMagick' unless Rails.env.test?

module ImageHelper
  def create_picture(file_url, user)
    file_name = create_file_name(user)
    img = Magick::Image::read(file_url).first
    img.density = "300x300"
    if img.columns < img.rows
      img = img.rotate(90)
    end
    img.resize_to_fill(1800,1200).write("tmp/#{file_name}")
    write_to_aws(user, file_name)
    "https://s3.amazonaws.com/booyahbooyah/#{file_name}"
  end

  def create_file_name(user)
    "user_#{user.id}_#{Time.now.to_i}.pdf"
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