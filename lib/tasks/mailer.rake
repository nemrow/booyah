require 'mailer.rb'

namespace :mailer do
  desc "rake mailer:email_all TEMPLATE=basic_template"
  task :email_all => :environment do
    users = User.all
    Mailer.new(users, ENV['SUBJECT'], ENV['TEMPLATE'])
  end
end