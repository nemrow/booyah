class PaypalPayment < ActiveRecord::Base
  attr_accessible :order_id, :status, :transaction_id

  belongs_to :order

  def self.init_payment_entry(paypal_params)
    payment_info = paypal_params.paymentInfoList.paymentInfo[0]
    payment_entry = self.create(
      :transaction_id => payment_info.transactionId,
      :status => payment_info.transactionStatus
    )
  end
end
