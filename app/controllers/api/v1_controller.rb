require "csv"
require_dependency "api_controller"

module Api
  class V1Controller < ApiController
    before_action :process_params
    respond_to :csv

    protected

    def process_params
      process_date_from
      process_date_to
      process_donor_account_ids
    end

    def process_date_from
      if params[:date_from].present?
        params[:date_from] = Date.strptime(params[:date_from], "%m/%d/%Y")
      end
    end

    def process_date_to
      if params[:date_to].present?
        params[:date_to] = Date.strptime(params[:date_to], "%m/%d/%Y")
      end
    end

    def process_donor_account_ids
      if params[:donor_account_ids].present?
        params[:donor_account_ids] = params[:donor_ids].split(",")
      end
    end

    def current_designation_profile
      @current_designation_profile ||= designation_profile_scope
        .find_by(id: params[:designation_profile_id])
    end

    def designation_profile_scope
      current_member.designation_profiles
    end

    def current_designation_profile_or_member
      current_designation_profile || current_member
    end

    def current_member
      @current_member ||= Member.find_by!(email: params[:user_email], access_token: params[:user_token])
    rescue ActiveRecord::NotFound
      render plain: "authentication error", status: :unauthorized
    end
  end
end
