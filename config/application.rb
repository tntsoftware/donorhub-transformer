# frozen_string_literal: true

require_relative 'boot'

require 'rails'

%w[
  active_record/railtie
  active_storage/engine
  action_controller/railtie
  action_view/railtie
  action_mailer/railtie
  active_job/railtie
  action_cable/engine
  action_mailbox/engine
  action_text/engine
].each do |railtie|
  require railtie
end
require 'csv'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Settings in config/environments/* take precedence over those specified here.
# Application configuration should go into files in config/initializers
# -- all .rb files in that directory are automatically loaded.
# Settings in config/environments/* take precedence over those specified here.
# Application configuration should go into files in config/initializers
# -- all .rb files in that directory are automatically loaded.
module DonorhubTransformer; end

class DonorhubTransformer::Application < Rails::Application
  config.generators do |g|
    g.orm :active_record, primary_key_type: :uuid
    g.test_framework :rspec,
                     fixtures: true,
                     view_specs: false,
                     helper_specs: false,
                     routing_specs: false,
                     controller_specs: false,
                     request_specs: false
    g.fixture_replacement :factory_bot, dir: 'spec/factories'
  end

  # Initialize configuration defaults for originally generated Rails version.
  config.load_defaults 6.0

  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
end
