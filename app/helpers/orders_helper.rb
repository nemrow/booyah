module OrdersHelper
  # @lob = Lob(api_key: ENV['LOB_KEY'])
  def create_new_order(user, image_hash)
    postcard = order_new_postcard(user, image_hash[:pdf])
    if postcard
      order = add_order_to_db(user, postcard, image_hash, 1.50)
      order
    else
      p "error trying to order postcard: #{postcard}"
      false
    end
  end

  def order_new_postcard(user, picture)
    lob = Lob(api_key: ENV['LOB_KEY'])
    lob.postcards.create(
      "#{user.first_name} #{user.last_name}\'s Order",
      user.address.lob_address_id,
      message: "Thanks for using Booyah!",
      front: picture,
      from: Rails.env.production? ? 'adr_d06d2d0316a1cd0f' : 'adr_5860b42d2df0309e'
    )
  end

  def add_order_to_db(user, postcard, image_hash, user_cost)
    order = Order.create( :user_id => user.id,
                          :to_id => postcard['to'],
                          :order_id => postcard['id'],
                          :lob_cost => postcard['price'],
                          :user_cost => user_cost,
                          :pdf_source => image_hash[:pdf],
                          :jpg_source => image_hash[:jpg]
                        )
    user.orders << order
    order
  end

  def create_new_address(address_params)
    @lob = Lob(api_key: ENV['LOB_KEY'])
    new_address = Address.new(address_params)
    address_params.merge!(  :name => current_user.full_name,
                            :email => current_user.email,
                            :phone => current_user.cell
                          )
    new_lob_address = @lob.addresses.create(address_params)
    new_address.lob_address_id = new_lob_address['id']
    new_address.save
    current_user.addresses << new_address
    new_lob_address
  end

  def update_address(address_params, address)
    @lob = Lob(api_key: ENV['LOB_KEY'])
    address_params.merge!(  :name => current_user.full_name,
                            :email => current_user.email,
                            :phone => current_user.cell
                          )
    new_lob_address = @lob.addresses.create(address_params)
    address_params.merge!(:lob_address_id => new_lob_address['id'])
    address.update_lob_friendly_attributes(address_params)
    new_lob_address
  end

  def verify_and_create_address(address_params)
    @lob = Lob(api_key: ENV['LOB_KEY'])
    begin
      @lob.addresses.verify(address_params.dup)
      create_new_address(address_params)
    rescue
      false
    end
  end

  def verify_and_update_address(address, address_params)
    @lob = Lob(api_key: ENV['LOB_KEY'])
    begin
      @lob.addresses.verify(address_params.dup)
      update_address(address_params, address)
    rescue
      false
    end
  end
end