# frozen_string_literal: true

namespace :integration do
  desc 'Run all integration syncs'
  task sync: :environment do
    ::Integration.find_each(&:sync)
  end
end
