# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  append_view_path Rails.root.join('app', 'views', 'mailers')
  default from: ENV['ORG_CONTACT_EMAIL']
  layout 'mailer'
end
