namespace :xero do
  desc 'Sync From Xero'
  task sync: :environment do
    XeroSyncJob.perform_now
  end
  desc 'Sync All From Xero'
  task sync_all: :environment do
    XeroSyncJob.perform_now(1.year.ago)
  end
end
