# frozen_string_literal: true

module FixtureHelpers
  def json_data(file_name)
    JSON.parse(data(file_name), symbolize_names: true)
  end

  def data(file_name)
    file_fixture("#{file_name}.json").read
  end
end
