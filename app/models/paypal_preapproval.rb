class PaypalPreapproval < ActiveRecord::Base
  attr_accessible :active, :key, :user_id

  belongs_to :user

  def activate
    update_attributes(:active => true)
    user.paypal_preapprovals.where("active = false").destroy_all
  end

  def self.get_preapproval_key(user)
    @api = PayPal::SDK::AdaptivePayments::API.new
    users_preapproval = PaypalPreapproval.create
    @preapproval = @api.build_preapproval({
      :cancelUrl => "#{ENV['BASE_URL']}/users/#{user.id}?error=payment%20broke",
      :currencyCode => "USD",
      :returnUrl => "#{ENV['BASE_URL']}/users/#{user.id}/preapproval/#{users_preapproval.id}",
      :memo => "You will only be charged $2 per order placed via text",
      :startingDate => Time.now,
      :endingDate => Time.now + 364.days,
      :maxTotalAmountOfAllPayments => 500 
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

  def self.get_preapproval_url(user)
    if preapproval_key = get_preapproval_key(user)
      if ENV['PAYPAL_MODE'] == 'live'
        "https://www.paypal.com/cgi-bin/webscr?cmd=_ap-preapproval&preapprovalkey=#{preapproval_key}"        
      else
        "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_ap-preapproval&preapprovalkey=#{preapproval_key}"
      end
    else
      p preapproval_key
      false
    end
  end

  def self.check_approval_status(user)
    if user.preapproval
      @api = PayPal::SDK::AdaptivePayments::API.new
      @preapproval_details = @api.build_preapproval_details({
        :preapprovalKey => user.preapproval.key 
      })
      @preapproval_details_response = @api.preapproval_details(@preapproval_details)
      if @preapproval_details_response.success?
        @preapproval_details_response.status
      else
        p "could not get status"
        p @preapproval_details_response
        "could not access. refresh to try again"
      end
    else
      false
    end
  end
end
