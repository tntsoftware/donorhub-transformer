# https://www.tntware.com/donorhub/groups/developers/wiki/how-can-my-fundraising-app-use-the-donorhub-api.aspx
# ADDRESSES QUERY

require_dependency "api/v1_controller"

module Api
  module V1
    class DonorAccountsController < V1Controller
      def create
        load_donor_accounts
        filter_donor_accounts
      end

      protected

      def load_donor_accounts
        @donor_accounts ||= donor_account_scope.by_date_range(params[:date_from], params[:date_to])
      end

      def filter_donor_accounts
        return unless params[:donor_account_ids] && params[:donor_account_ids].empty?
        @donor_accounts = donor_accounts.where(donor_account_id: params[:donor_account_ids])
      end

      def donor_account_scope
        current_designation_profile_or_member.donor_accounts.distinct
      end
    end
  end
end
