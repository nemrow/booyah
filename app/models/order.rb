class Order < ActiveRecord::Base
  attr_accessible :order_id, :to_id, :user_id, :lob_cost, :user_cost, :pdf_source, :jpg_source

  belongs_to :user
  has_one :paypal_payment
end
