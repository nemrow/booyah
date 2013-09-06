module PaypalHelper
  def get_preapproval_key(user)
    @api = PayPal::SDK::AdaptivePayments::API.new
    users_preapproval = PaypalPreapproval.create
    @preapproval = @api.build_preapproval({
      :cancelUrl => "http://localhost:3000/users/#{user.id}/addresses/user.address.id/edit?error=payment%20broke",
      :currencyCode => "USD",
      :returnUrl => "http://localhost:3000/users/#{user.id}/preapproval/#{users_preapproval.id}",
      :memo => "You will only be charged $1.50 per order placed via text",
      :startingDate => Time.now 
    })
    @preapproval_response = @api.preapproval(@preapproval)
    if @preapproval_response.success?
      users_preapproval.update_attributes(:key => @preapproval_response.preapprovalKey)
      user.paypal_preapprovals << users_preapproval
      @preapproval_response.preapprovalKey
    else
      p @preapproval_response.error
      false
    end
  end

  def get_preapproval_url(user)
    if preapproval_key = get_preapproval_key(user)
      "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_ap-preapproval&preapprovalkey=#{preapproval_key}"
    else
      p preapproval_key
      false
    end
  end
end