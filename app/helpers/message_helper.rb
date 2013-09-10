module MessageHelper
  def flash(instance, params = {})
    case instance

    when "new user basic success"
      "Hello #{params[:user].first_name}, you're almost ready to start printing!"
    when "new user basic fail"
      "We are unable to create an account with the info you provided. Please try again."
    end
  end
end