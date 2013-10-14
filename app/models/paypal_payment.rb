class PaypalPayment < ActiveRecord::Base
  attr_accessible :order_id, :status, :transaction_id

  belongs_to :order

  @@api = PayPal::SDK::AdaptivePayments::API.new

  def self.init_payment_entry(paypal_params)
    payment_info = paypal_params.paymentInfoList.paymentInfo[0]
    payment_entry = self.create(
      :transaction_id => payment_info.transactionId,
      :status => payment_info.transactionStatus
    )
  end

  def self.make_approved_payment(user, amount)
    pay = @@api.build_pay({
      :actionType => "PAY",
      :preapprovalKey => user.preapproval.key,
      :currencyCode => "USD",
      :feesPayer => "EACHRECEIVER",
      :returnUrl => ENV['BASE_URL'],
      :cancelUrl => ENV['BASE_URL'],
      :receiverList => {
        :receiver => [{
          :amount => amount,
          :email => ENV['PAYPAL_EMAIL'] 
        }] 
      }
    })
    pay_response = @@api.pay(pay)
    if pay_response.success?
      PaypalPayment.init_payment_entry(pay_response)
    else
      User.send_sms({:message_code => 6, :user => user, :cell => user.cell})
      false
    end
  end

  def self.refund(payment)
    refund = @@api.build_refund({
      :transactionId => payment.transaction_id,
      :currencyCode => "USD"
    })
    refund_response = @@api.refund(refund)
    if refund_response.success?
      # should record this into a refund table
    else
      false
    end
  end
end
