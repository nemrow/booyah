@user = User.create( :name => 'Jordan Nemrow',
                    :email => 'nemrowj@gmail.com',
                    :cell => '17078496085',
                    :password => 'password'
                  )
@address = Address.create( :address_line1 => '22 Weatherby ct.',
                          :address_line2 => '',
                          :city => 'Petaluma',
                          :state => 'CA',
                          :zip => '94954',
                          :country => 'US',
                          :lob_address_id => 'adr_429adf52853ec0a7',
                          :primary => true
                        )
@user.addresses << @address
3.times do |num|
  order = Order.create( :to_id => 'adr_429adf52853ec0a7',
                        :order_id => "lob_id_num_#{num}",
                        :jpg_source => 'https://s3.amazonaws.com/booyahbooyah/user_4_1378395726.jpg',
                        :pdf_source => 'https://s3.amazonaws.com/booyahbooyah/user_4_1378395726.pdf',
                        :lob_cost => 1.0,
                        :user_cost => 1.5
                      )
  @user.orders << order
end