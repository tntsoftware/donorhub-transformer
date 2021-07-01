# frozen_string_literal: true

class Integration < ApplicationRecord
  multi_tenant :organization
  store :payload, accessors: [], coder: JSON
end
