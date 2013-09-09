PayPal::SDK.configure(
  :mode      => Rails.env.production?  ? "live" : "sandbox",
  :app_id    => ENV['PAYPAL_APP_ID'],
  :username  => ENV['PAYPAL_USERNAME'],
  :password  => ENV['PAYPAL_PASSWORD'],
  :signature => ENV['PAYPAL_SIGNATURE']
)

PayPal::SDK.logger = Rails.logger