class PaypalPreapproval < ActiveRecord::Base
  attr_accessible :active, :key, :user_id

  belongs_to :user

  def activate
    update_attributes(:active => true)
    user.paypal_preapprovals.where("active = false").destroy_all
  end
end
