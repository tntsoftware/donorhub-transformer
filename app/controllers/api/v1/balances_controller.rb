# frozen_string_literal: true

# https://www.tntware.com/donorhub/groups/developers/wiki/how-can-my-fundraising-app-use-the-donorhub-api.aspx
# DESIGNATIONS QUERY

class Api::V1::BalancesController < Api::V1Controller
  def create
    load_designation_accounts
    send_data @designation_accounts.balances_as_csv(current_designation_profile_or_member)
  end

  protected

  def load_designation_accounts
    @designation_accounts ||= designation_account_scope.all
  end

  def designation_account_scope
    if current_designation_profile
      DesignationAccount.where(id: current_designation_profile.designation_account.id)
    else
      current_member.designation_accounts.distinct
    end
  end
end
