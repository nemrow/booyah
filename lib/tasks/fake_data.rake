namespace :fake_data do
  desc "create data"
  task :create_admin => :environment do
    @user = User.create(
      :name => 'Jordan Nemrow',
      :email => 'jordan@nemrow.com',
      :cell => '(555) 666-4444',
      :password => 'password',
      :role => 'admin'
    )
    @address = Address.create(
      :name => 'Grammie and Poppa',
      :address_line1 => '22 Weatherby ct.',
      :address_line2 => '',
      :city => 'Petaluma',
      :state => 'CA',
      :zip => '94954',
      :country => 'US'
    )
    @user.addresses << @address
    @paypal_preapproval = PaypalPreapproval.create(:key => 'PA-9RF40956PG755650W')
    @user.paypal_preapprovals << @paypal_preapproval
    @paypal_preapproval.activate
    @order = Order.create(
      :to_id => "adr_39dd19dac0a5876a",
      :lob_order_id => "job_1090046c4d77d278", 
      :pdf_source => "https://s3.amazonaws.com/booyahbooyah/user_52_13790",
      :jpg_source => "https://s3.amazonaws.com/booyahbooyah/user_52_13790",
      :lob_cost => 1.21,
      :user_cost => 1.5,
      :lob_object_id => "obj_8f939617219ad8e"
    )
    @picture = Picture.create(
      :pdf_source => "https://s3.amazonaws.com/booyahbooyah/user_1_1379982196.pdf",
      :jpg_source => "https://s3.amazonaws.com/booyahbooyah/user_1_1379982196.jpg"
    )
    @order.picture = @picture
    @order.address = @address
    @paypal_payment = PaypalPayment.create(:transaction_id => '3YV02934GD864243A', :status => 'COMPLETED')
    @user.orders << @order
  end
end