require_dependency "application_controller"

module Api
  module V1
    class QueriesController < ApplicationController
      def show
        send_data render_to_string("show", formats: [:text]), filename: "query.ini"
      end
    end
  end
end
