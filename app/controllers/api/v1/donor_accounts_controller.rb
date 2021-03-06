# frozen_string_literal: true

# https://www.tntware.com/donorhub/groups/developers/wiki/how-can-my-fundraising-app-use-the-donorhub-api.aspx
# ADDRESSES QUERY

class Api::V1::DonorAccountsController < Api::V1Controller
  def create
    send_data donor_accounts.as_csv
  end

  protected

  def donor_accounts
    return @donor_accounts if @donor_accounts

    @donor_accounts = donor_account_scope.by_date_range(params[:date_from], params[:date_to])
    return @donor_accounts unless params[:donor_account_ids]&.any?

    @donor_accounts = @donor_accounts.where(id: params[:donor_account_ids])
  end

  def donor_account_scope
    current_designation_profile_or_member.donor_accounts.distinct
  end
end
