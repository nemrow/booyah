module MessageHelper
  def format_errors(messages)
    message_text = "<h4>Errors</h4>"
    messages.each do |message|
      message_text += "<p>#{message[0].to_s}</p>"
      message_text += "<ul>"
      message[1].each do |indi_message|
        message_text += "<li>#{indi_message}</li>"
      end
      message_text += "</ul>"
    end
    p message_text
  end

  def format_plain_error(message)
    "<h4>Errors</h4><ul><li>"+message+"</li></ul>"
  end

  def flash(instance, params = {})
    case instance

    when "new user basic success"
      "Hello #{params[:user].first_name}, you're almost ready to start printing!"
    when "new user basic fail"
      "We are unable to create an account with the info you provided. Please try again."
    end
  end
end