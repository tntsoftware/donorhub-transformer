# frozen_string_literal: true

class Api::V1::QueriesController < ApplicationController
  def show
    send_data render_to_string(template: 'api/v1/queries/show', formats: [:text]), filename: 'query.ini'
  end
end
