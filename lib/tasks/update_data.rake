namespace :update_data do
  desc "TODO"
  task :add_names_to_existing_addresses => :environment do
    Address.all.each do |address|
      if address.name == "" || address.name == nil
        address.update_attributes(:name => address.user.name)
      end
    end
  end

  task :downcase_fields => :environment do
    Address.all.each do |address|
      address.update_attributes(:name => address.name.downcase)
    end
  end

  task :make_users_first_address_default => :environment do
    User.all.each do |user|
      if user.addresses.select{|address| address.default == true}.count < 1
        user.addresses.first.update_attributes(:default => true)
      end
    end
  end

  task :port_images_to_table => :environment do
    Order.all.each do |order|
      pic = Picture.create(
        :pdf_source => order.pdf_source,
        :jpg_source => order.jpg_source, 
        :lob_object_id => order.lob_object_id
        )
      order.picture = pic
    end
  end

  task :downcase_emails => :environment do
    User.all.each do |user|
      user.email = user.email.downcase
      user.save
    end
  end

  task :set_return_addresses => :environment do
    User.all.each do |user|
      user.save # user model has a before save method that creates the return address
    end
  end
end
