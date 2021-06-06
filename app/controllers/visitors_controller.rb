# frozen_string_literal: true

class VisitorsController < ApplicationController
  def index
    redirect_to admin_root_path if current_user&.admin?
  end
end
