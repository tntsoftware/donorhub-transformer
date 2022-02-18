# frozen_string_literal: true

class Xero::DesignationAccountsService < Xero::BaseService
  def load
    tracking_category_scope.each do |tracking_category|
      tracking_category.options.each do |tracking_option|
        attributes = designation_account_attributes(tracking_category, tracking_option)
        record = DesignationAccount.find_or_initialize_by(remote_id: attributes[:remote_id])
        record.attributes = attributes
        record.save!
      end
    end
  end

  private

  def tracking_category_scope
    return client.TrackingCategory.all if all

    client.TrackingCategory.all(modified_since: modified_since)
  rescue Xeroizer::OAuth::TokenExpired
    integration.refresh_access_token
    retry
  rescue Xeroizer::OAuth::RateLimitExceeded
    sleep 60
    retry
  end

  def designation_account_attributes(tracking_category, tracking_option, attributes = {})
    attributes[:name] = "#{tracking_category.name}:#{tracking_option.name}"
    attributes[:remote_id] = "#{tracking_category.id}:#{tracking_option.id}"
    attributes
  end
end
