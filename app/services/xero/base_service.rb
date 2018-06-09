module Xero
  class BaseService
    attr_accessor :modified_since

    def self.load(modified_since = Time.zone.now.beginning_of_month - 2.months)
      service = new
      service.modified_since = modified_since
      service.load
    end

    def load; end

    def client
      @client ||= Xeroizer::PrivateApplication.new(
        ENV["XERO_OAUTH_CONSUMER_KEY"],
        ENV["XERO_OAUTH_CONSUMER_SECRET"],
        nil,
        private_key: ENV["XERO_PRIVATE_KEY"],
      )
    end
  end
end
