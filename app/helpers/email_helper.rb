module EmailHelper

  def admin_error_email(message)
    send_email(
      'nemrowj@gmail.com',
      'error occured',
      message
      )
  end

  def send_non_active_users_email(user_list)
    user_list.each do |user|
      send_basic_email(
        user.email,
        "Start printing today & get more free prints! - Pigeon",
        user.first_name,
        non_active_user_copy,
        "Dan from Pigeon <Dan.polaske@gmail.com>",
        "Dan"
      )
    end
  end

  def non_active_user_copy
    "Thank you for being one of the first people to try out Pigeon!<br><br>" +
    "<b>Are you ready to start printing?</b><br>" +
    "All you need to do is connect your Paypal account and you will be ready to go." +
    "You can do this on your account page: <a href='http://www.pigeonpic.com/signin'>http://www.pigeonpic.com/signin</a><br><br>" +
    "<b>No longer interested in activating your account? Do not want to use Paypal?</b><br>" +
    "Please reply to this email with any questions or concerns. We would love to hear from you!<br><br>" +
    "<i>Connect your Paypal account in the next 24 hours, and I will credit your account with a few more free prints!</i>"
  end

  def send_basic_email(to, subject, user_name, content, from_email, from_name)
    send_email( to, subject, basic_template({ :to => user_name, :content => content, :from => from_name }), from_email)
  end
  
  def send_email(to, subject, content, from)
    RestClient.post "https://api:#{ENV['MAILGUN_KEY']}@api.mailgun.net/v2/pigeonpic.com"+"/messages", 
    :from => from,
    :to => to,
    :subject => subject,
    :html => content
  end

  private
  def basic_template(params)
    p params
    html = ""
    html += "<p><b>Hey #{params[:to]},</b><br><br>"
    html += params[:content]
    html += "<p style=\"font-size:16px;\">#{params[:from]}<br>
    <span style=\"font-size:14px;\">Co-Founder @ Pigeon</span>
    </p>"
    html
  end

  def quote_escape(content)
    content.gsub(/'/, "\\'").gsub(/"/,'\\"')
  end
end