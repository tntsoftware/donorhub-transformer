# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { create(:user, email: 'user@example.com') }

  it { is_expected.to respond_to(:email) }

  it '#email returns a string' do
    expect(user.email).to match 'user@example.com'
  end
end
