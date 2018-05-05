require 'csv'

module Api
  class V1Controller < ApiController
    acts_as_token_authentication_handler_for User
    before_action :process_params
    respond_to :csv

    protected

    def process_params
      process_date_from
      process_date_to
      process_donor_account_ids
    end

    def process_date_from
      params[:date_from] = Date.strptime(params[:date_from], '%m/%d/%Y') if params[:date_from].present?
    end

    def process_date_to
      params[:date_to] = Date.strptime(params[:date_to], '%m/%d/%Y') if params[:date_to].present?
    end

    def process_donor_account_ids
      params[:donor_account_ids] = params[:donor_ids].split(',') if params[:donor_account_ids].present?
    end

    def current_designation_profile
      @current_designation_profile ||= designation_profile_scope.find_by(id: params[:designation_profile_id])
    end

    def designation_profile_scope
      current_user.designation_profiles
    end

    def current_designation_profile_or_user
      current_designation_profile || current_user
    end
  end
end
