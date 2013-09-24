class Order < ActiveRecord::Base
  attr_accessible :lob_order_id, :to_id, :user_id, :lob_cost, :user_cost, :pdf_source, :jpg_source, :lob_object_id

  belongs_to :user
  has_one :paypal_payment
  has_one :picture

  @@lob = Lob(api_key: ENV['LOB_KEY'])

  def self.handle_incoming_message(params)
    user = User.verify_status(params)
    return false if !user
    receiver = user.verify_receiver(params)
    return false if !receiver
    image = Picture.verify_image(params, user)
    return false if !image
    credits = user.available_credits
    order = create_new_print_order(user, image, receiver)
    if credits < 1
      order ? User.send_sms({:message_code => 1, :order => order, :receiver => receiver, :cell => user.cell}) : User.send_sms({:message_code => 6, :user => user, :cell => user.cell})
    else
      order ? User.send_sms({:message_code => 5, :order => order, :receiver => receiver, :cell => user.cell}) : User.send_sms({:message_code => 2, :user => user, :cell => user.cell})      
    end
  end

  def self.create_new_print_order(user, image, receiver, amount = 1.50)
    if user.available_credits > 0
      user.make_credit_transaction(-1, "order")
    else
      payment = PaypalPayment.make_approved_payment(user, amount)
    end
    return false if payment == false
    if print = order_new_print(user, image.pdf_source, receiver)
      add_print_order_to_db(user, print, image, amount, payment)
    else
      p "trouble sending order to Lob"
      false
    end
  end

  def self.order_new_print(user, picture, receiver)
    object = Picture.create_new_object(user, picture)
    @@lob.jobs.create("#{user.name}\'s Job", receiver.lob_address_id, object['id'])
  end

  def self.add_print_order_to_db(user, print, image, user_cost, payment)
    order = Order.create( :user_id => user.id,
                          :to_id => print['to']['id'],
                          :lob_order_id => print['id'],
                          :lob_cost => print['price'],
                          :user_cost => user_cost
                        )
    image.lob_object_id = print['objects'][0]['id']
    image.order = order
    image.save
    order.paypal_payment = payment
    user.orders << order
    order.save
    order
  end
end
