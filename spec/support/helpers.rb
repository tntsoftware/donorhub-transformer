# frozen_string_literal: true

require 'support/helpers/fixture_helpers'
require 'support/helpers/features/session_helpers'

RSpec.configure do |config|
  config.include FixtureHelpers
  config.include Features::SessionHelpers, type: :feature
end
