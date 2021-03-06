# frozen_string_literal: true

# https://www.tntware.com/donorhub/groups/developers/wiki/how-can-my-fundraising-app-use-the-donorhub-api.aspx
# DESIGNATIONS QUERY

class Api::V1::DesignationAccountsController < Api::V1Controller
  def create
    send_data designation_accounts.as_csv
  end

  protected

  def designation_accounts
    @designation_accounts ||= designation_account_scope.all
  end

  def designation_account_scope
    if current_designation_profile
      current_member.designation_accounts.where(id: current_designation_profile.designation_account_id)
    else
      current_member.designation_accounts
    end
  end
end
