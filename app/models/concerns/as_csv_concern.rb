# frozen_string_literal: true

module AsCsvConcern
  extend ActiveSupport::Concern

  class_methods do
    def as_csv
      CSV.generate do |csv|
        csv << new.as_csv.keys
        all.each do |record|
          csv << record.as_csv.values
        end
      end
    end
  end
end
