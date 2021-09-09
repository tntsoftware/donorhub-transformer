# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { create(:user, email: 'user@example.com') }

  it { is_expected.to have_many(:members).dependent(:destroy) }
  it { is_expected.to have_many(:organizations).through(:members) }

  describe '#email' do
    it { is_expected.to respond_to(:email) }

    it '#email returns a string' do
      expect(user.email).to match 'user@example.com'
    end
  end

  describe '#after_add_role' do
    let(:organization) { create(:organization) }

    it 'creates member' do
      user.add_role(:member, organization)
      expect(organization.members.where(user: user)).to exist
    end
  end

  describe '#after_remove_role' do
    let(:organization) { create(:organization) }
    let(:member) { Member.find_by(user: user, organization: organization) }

    before { user.add_role(:member, organization) }

    it 'destroys member' do
      user.remove_role(:member, organization)
      expect(organization.members.where(user: user)).not_to exist
    end
  end
end
