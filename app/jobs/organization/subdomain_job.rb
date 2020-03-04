# frozen_string_literal: true

require 'platform-api'

class Organization::SubdomainJob < ActiveJob::Base
  queue_as :default

  def perform(subdomain, action)
    case action
    when 'add'
      client.domain.create(ENV.fetch('HEROKU_APP_NAME'), 'hostname' => "#{subdomain}.#{ENV.fetch('DOMAIN_NAME')}")
    when 'remove'
      client.domain.delete(ENV.fetch('HEROKU_APP_NAME'), "#{subdomain}.#{ENV.fetch('DOMAIN_NAME')}")
    end
  rescue Excon::Error::UnprocessableEntity => e
    Rollbar.error(e)
  end

  protected

  def client
    @client ||= PlatformAPI.connect_oauth(ENV.fetch('HEROKU_API_KEY'))
  end
end
