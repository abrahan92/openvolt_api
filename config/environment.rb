# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!
Settings.load!

ActionMailer::Base.smtp_settings = {
  address: "smtp.sendgrid.net",
  port: 587,
  domain: "defaultapi.com",
  user_name: "apikey",
  password: ENV['SENDGRID_API_KEY'],
  authentication: "plain",
  enable_starttls_auto: true
}