# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.implicit_order_column = 'created_at'
  self.abstract_class = true
end
