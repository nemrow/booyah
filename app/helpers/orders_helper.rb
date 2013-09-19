module OrdersHelper
  @@lob = Lob(api_key: ENV['LOB_KEY'])

  def create_new_print_order(user, image_hash, amount = 1.50)
    if user.available_credits > 0
      user.make_credit_transaction(-1, "order")
    else
      payment = make_approved_payment(user, amount)
    end
    return false if payment == false
    if print = order_new_print(user, image_hash[:pdf])
      add_print_order_to_db(user, print, image_hash, amount, payment)
    else
      p "trouble sending order to Lob"
      false
    end
  end

  def order_new_print(user, picture)
    object = create_new_object(user, picture)
    @@lob.jobs.create("#{user.name}\'s Job", user.address.lob_address_id, object['id'])
  end

  def create_new_object(user, picture)
    if order = @@lob.objects.create("#{user.name}\'s Object", picture, 500)
      order
    else
      false
    end
  end

  def add_print_order_to_db(user, print, image_hash, user_cost, payment)
    order = Order.create( :user_id => user.id,
                          :to_id => print['to']['id'],
                          :lob_order_id => print['id'],
                          :lob_cost => print['price'],
                          :lob_object_id => print['objects'][0]['id'],
                          :user_cost => user_cost,
                          :pdf_source => image_hash[:pdf],
                          :jpg_source => image_hash[:jpg]
                        )
    order.paypal_payment = payment
    user.orders << order
    order
  end

  def create_new_address(address_params)
    new_address = Address.new(address_params)
    current_user.addresses << new_address
    address_params.merge!(  
      :email => current_user.email,
      :phone => current_user.cell
    )
    new_lob_address = @@lob.addresses.create(address_params)
    new_address.lob_address_id = new_lob_address['id']
    new_address.save
    new_lob_address
  end

  def update_address(address_params, address)
    address_params.merge!(  
      :email => current_user.email,
      :phone => current_user.cell
    )
    new_lob_address = @@lob.addresses.create(address_params)
    address_params.merge!(:lob_address_id => new_lob_address['id'])
    address.update_lob_friendly_attributes(address_params)
    new_lob_address
  end

  def verify_and_create_address(address_params)
    begin
      verify_address_via_lob(address_params.except(:keyword, :default, :name).dup)
      create_new_address(address_params)
    rescue Exception => e
      p e
      false
    end
  end

  def verify_address_via_lob(address_params)
    @@lob.addresses.verify(address_params.dup)
  end

  def verify_and_update_address(address, address_params)
    begin
      verify_address_via_lob(address_params.except(:keyword, :default, :name).dup)
      update_address(address_params, address)
    rescue
      false
    end
  end

  # Below are postcard ordering code which are not being used right now

  def add_postcard_order_to_db(user, postcard, image_hash, user_cost, payment)
    order = Order.create( :user_id => user.id,
                          :to_id => postcard['to'],
                          :lob_order_id => postcard['id'],
                          :lob_cost => postcard['price'],
                          :user_cost => user_cost,
                          :pdf_source => image_hash[:pdf],
                          :jpg_source => image_hash[:jpg]
                        )
    order.paypal_payment = payment
    user.orders << order
    order
  end

  def create_new_postcard_order(user, image_hash, amount = 1.50)
    if payment = make_approved_payment(user, amount)
      if postcard = order_new_postcard(user, image_hash[:pdf])
        add_postcard_order_to_db(user, postcard, image_hash, amount, payment)
      else
        p "error trying to order postcard: #{postcard}"
        false
      end
    else
      p "error. payment did not go through"
      p payment
      false
    end
  end

  def order_new_postcard(user, picture)
    @@lob.postcards.create(
      "#{user.name}\'s Order",
      user.address.lob_address_id,
      message: "Thanks for using Booyah!",
      front: picture,
      from: ENV['LOB_ADDRESS_KEY']
    )
  end
end