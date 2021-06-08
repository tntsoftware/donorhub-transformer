# frozen_string_literal: true

# https://www.tntware.com/donorhub/groups/developers/wiki/how-can-my-fundraising-app-use-the-donorhub-api.aspx
# ACCOUNT_BALANCE QUERY

class Api::V1::BalancesController < Api::V1Controller
  def create
    send_data designation_profiles.balances_as_csv
  end

  protected

  def designation_profiles
    @designation_profiles ||= designation_profile_scope.all
  end
end
