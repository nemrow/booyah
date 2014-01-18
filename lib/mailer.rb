class Mailer
  def initialize(users, template, opts={})
    @users = users
    @subject = "Add a Personal Message - Pigeon Pic"
    @template = "emails/#{template}"
    @opts = opts
    begin_mailing
  end

  def begin_mailing
    @users.each do |user|
      html = build_html(user)
      begin
        message = send_single_message(user, html)
        p message
      rescue Exception => e
        p "user #{user.id} FUCKED UP"
      end
    end
  end

  def build_html(user)
    ac = ActionController::Base.new()
    locals = @opts.merge({:user => user})
    ac.render_to_string(:template => "emails/basic_template", :layout => false, :locals => locals)
  end

  def send_single_message(user, html)
    RestClient.post "https://api:#{ENV['MAILGUN_KEY']}@api.mailgun.net/v2/pigeonpic.com"+"/messages", 
    :from => "Dan Polaske <Dan.polaske@gmail.com>",
    :to => user.email,
    :subject => @subject,
    :html => html
  end
end