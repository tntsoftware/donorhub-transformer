# https://www.tntware.com/donorhub/groups/developers/wiki/how-can-my-fundraising-app-use-the-donorhub-api.aspx
# DESIGNATIONS QUERY

class Api::V1::DesignationAccountsController < V1Controller
  def create
    load_designation_accounts
  end

  protected

  def load_designation_accounts
    @designation_accounts ||= designation_account_scope.all
  end

  def designation_account_scope
    current_designation_profile_or_member.designation_accounts.distinct
  end
end
