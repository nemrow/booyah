class Order < ActiveRecord::Base
  attr_accessible :order_id, :to_id, :user_id, :lob_cost, :user_cost

  belongs_to :user
end
