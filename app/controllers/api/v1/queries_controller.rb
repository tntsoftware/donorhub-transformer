# frozen_string_literal: true

class Api::V1::QueriesController < ApplicationController
  skip_after_action :verify_authorized

  def show
    stream = render_to_string('show', formats: [:text], locals: { current_organization: current_organization })
    send_data stream, filename: 'query.ini'
  end
end
