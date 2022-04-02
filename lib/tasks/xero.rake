# frozen_string_literal: true

namespace :xero do
  desc "Sync From Xero"
  task sync: :environment do
    XeroService.load
  end
  desc "Sync All From Xero"
  task sync_all: :environment do
    XeroService.load(all: true)
  end
end
