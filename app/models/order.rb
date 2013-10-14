class Order < ActiveRecord::Base
  attr_accessible :lob_order_id, :to_id, :address_id, :user_id, :lob_cost, :user_cost, :pdf_source, :jpg_source, :lob_object_id

  belongs_to :user
  belongs_to :address
  has_one :paypal_payment
  has_one :picture

  @@lob = Lob(api_key: ENV['LOB_KEY'])

  def formatted_date
    created_at.strftime('%B %d, %Y')
  end

  def self.handle_incoming_message(params)
    user = User.verify_status(params)
    return false if !user
    receiver = user.verify_receiver(params)
    return false if !receiver
    image = Picture.verify_image(params, user)
    return false if !image
    credits = user.available_credits
    payment = decide_payment_type(user, 1.50)
    return false if payment == false
    order = create_new_print_order(user, image, receiver, payment)
    return false if order == false
    if credits < 1
      User.send_sms({:message_code => 1, :order => order, :receiver => receiver, :cell => user.cell})
    else
      User.send_sms({:message_code => 5, :order => order, :receiver => receiver, :cell => user.cell})
    end
  end

  def self.create_new_print_order(user, image, receiver, payment)
    if print = order_new_print(user, image.pdf_source, receiver)
      add_print_order_to_db(user, print, image, 1.50, payment, receiver)
    else
      User.send_sms({:message_code => 12, :user => user, :cell => user.cell})
      # make a refund here for the payment
      false
    end
  end

  def self.decide_payment_type(user, amount)
    if user.available_credits > 0
      user.make_credit_transaction(-1, "order")
      'credit'
    else
      PaypalPayment.make_approved_payment(user, amount)
    end
  end

  def self.order_new_print(user, picture, receiver)
    object = Picture.create_new_object(user, picture)
    begin
      @@lob.jobs.create(
        "#{user.name}\'s Job", 
        receiver.lob_address_id, 
        object['id'],
        :from => Order.pigeon_address
      )
    rescue
      false
    end
  end

  def self.add_print_order_to_db(user, print, image, user_cost, payment, receiver)
    order = print_friendly_create_order(user, print, user_cost, receiver)
    update_image_in_db(image, print, order)
    update_payment_source_in_db(payment, order)
    user.orders << order
    order.save
    order
  end

  def self.pigeon_address
    ENV['PIGEON_ADDRESS_ID']
  end

  def self.print_friendly_create_order(user, print, user_cost, receiver)
    order = Order.create( 
      :user_id => user.id,
      :to_id => print['to']['id'],
      :lob_order_id => print['id'],
      :lob_cost => print['price'],
      :user_cost => user_cost
    )
    receiver.orders << order
    order
  end

  def self.update_image_in_db(image, print, order)
    image.lob_object_id = print['objects'][0]['id']
    image.order = order
    image.save
  end

  def self.update_payment_source_in_db(payment, order)
    if payment == 'credit'
      order.payment_source = 'credit'
    else
      order.payment_source = 'paypal'
      order.paypal_payment = payment
    end
  end
end
