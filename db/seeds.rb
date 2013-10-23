require 'faker'

@@user = User.create( :name => 'Jordan Nemrow',
                    :email => 'nemrowj@gmail.com',
                    :cell => '(707) 849-6085',
                    :password => 'password',
                    :role => 'admin'
                  )
@@address = Address.create( :address_line1 => '22 Weatherby ct.',
                            :address_line2 => '',
                            :city => 'Petaluma',
                            :state => 'CA',
                            :zip => '94954',
                            :country => 'US',
                            :lob_address_id => 'adr_429adf52853ec0a7',
                            :name => 'Grammie and Poppa'
                        )
@@user.addresses << @@address

3.times do |num|
  order = Order.create( :to_id => 'adr_429adf52853ec0a7',
                        :lob_order_id => "job_0b149ecfe75b1748",
                        :lob_object_id => "obj_90dceeac856a54b3",
                        :lob_cost => 1.0,
                        :user_cost => 1.5,
                        :address_id => @@address.id
                      )
  pic = Picture.create(
    :pdf_source => 'https://s3.amazonaws.com/booyahbooyah/user_4_1378395726.pdf',
    :jpg_source => 'https://s3.amazonaws.com/booyahbooyah/user_4_1378395726.jpg',
    :lob_object_id => 'obj_siusys9sh0'
  )
  order.picture = pic
  @@user.orders << order
end

6.times do
  user = User.create(
    :name => Faker::Name.name,
    :email => Faker::Internet.email,
    :cell => "(#{rand(111..999)} #{rand(111.999)}-#{rand(1111.9999)}",
    :password => rand(11111.99999)
  )
  p user
end

