# https://www.tntware.com/donorhub/groups/developers/wiki/how-can-my-fundraising-app-use-the-donorhub-api.aspx
# DONATIONS QUERY

class Api::V1::DonationsController < V1Controller
  def create
    load_donations
  end

  protected

  def load_donations
    @donations ||= donation_scope.by_date_range(params[:date_from], params[:date_to])
  end

  def donation_scope
    current_designation_profile_or_member.donations.distinct
  end
end
