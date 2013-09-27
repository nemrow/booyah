module EmailHelper

  def admin_error_email(message)
    send_email(
      'nemrowj@gmail.com',
      'error occured',
      message
      )
  end

  def send_basic_email(email, subject, name, paragraphs)
    send_email( email, subject, basic_template({ :name => name, :paragraphs => paragraphs }))
  end
  
  def send_email(to, subject, message, from = 'jordan@pigeonpic.com')
    RestClient.post "https://api:#{ENV['MAILGUN_KEY']}@api.mailgun.net/v2/pigeonpic.com"+"/messages", 
    :from => from,
    :to => to,
    :subject => subject,
    :html => message
  end

  private
  def basic_template(params)
    p params
    html = ""
    html += "<p><b>Hello #{params[:name]},</b><br><br>"
    params[:paragraphs].each do |paragraph|
      html += "#{paragraph}<br><br>"
    end
    html += "<p style=\"font-size:16px;\">Jordan Nemrow<br>
    <span style=\"font-size:14px;\">Pigeon</span><br>
    <span style=\"font-size:12px; font-style:italic\">gettin physical with photos again</span>
    </p>"
    html
  end

  def quote_escape(content)
    content.gsub(/'/, "\\'").gsub(/"/,'\\"')
  end
end