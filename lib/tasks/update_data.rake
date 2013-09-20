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
end
