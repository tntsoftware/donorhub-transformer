# https://www.tntware.com/donorhub/groups/developers/wiki/how-can-my-fundraising-app-use-the-donorhub-api.aspx
# DONATIONS QUERY

module Api
  module V1
    class DonationsController < V1Controller
      def create
        load_donations
      end

      protected

      def load_donations
        @donations ||= donation_scope.by_date_range(params[:date_from], params[:date_to])
      end

      def donation_scope
        current_designation_profile_or_user.donations.distinct
      end
    end
  end
end
