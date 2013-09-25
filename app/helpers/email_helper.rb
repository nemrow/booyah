module EmailHelper

  def admin_error_email(message)
    send_email(
      'nemrowj@gmail.com',
      'error occured',
      message
      )
  end
  
  def send_email(to, subject, message, from = 'Jordan@pigeonpic.com')
    RestClient.post "https://api:#{ENV['MAILGUN_KEY']}@api.mailgun.net/v2/booyahbooyah.com"+"/messages", 
        :from => from,
        :to => to,
        :subject => subject,
        :html => "<b>HTML</b>#{message}!"
  end
end