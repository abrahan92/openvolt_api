# app/mailers/custom_devise_mailer.rb

class CustomDeviseMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers

  def reset_password_instructions(record, token, opts={})
    @request_from = record.request_from
    super
  end

  def confirmation_instructions(record, token, opts={})
    @request_from = record.request_from
    super
  end
end