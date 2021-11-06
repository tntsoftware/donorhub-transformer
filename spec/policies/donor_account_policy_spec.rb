# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DonorAccountPolicy do
  subject(:policy) { described_class.new(user, donor_account) }

  let(:organization) { create(:organization) }
  let(:user) { create(:user) }
  let!(:donor_account) { create(:donor_account, organization: organization) }
  let(:donation) { create(:donation, organization: organization, donor_account: donor_account) }

  let(:resolved_scope) do
    described_class::Scope.new(user, organization.donor_accounts).resolve
  end

  it { is_expected.to permit_actions(%i[index]) }
  it { is_expected.to forbid_actions(%i[create new show update edit destroy]) }

  it 'excludes donor_account in scope' do
    expect(resolved_scope).not_to include(donor_account)
  end

  context 'with member role' do
    let(:user) { create(:user) }

    before { user.add_role(:member, organization) }

    it { is_expected.to permit_actions(%i[index]) }
    it { is_expected.to forbid_actions(%i[create new show update edit destroy]) }

    it 'excludes donor_account in scope' do
      expect(resolved_scope).not_to include(donor_account)
    end
  end

  context 'with designation_profile' do
    before do
      user.add_role(:member, organization)
      create(
        :designation_profile,
        designation_account: donation.designation_account,
        member: organization.members.find_by(user: user)
      )
    end

    it { is_expected.to permit_actions(%i[index show]) }
    it { is_expected.to forbid_actions(%i[create new update edit destroy]) }

    it 'includes donor_account in scope' do
      expect(resolved_scope).to include(donor_account)
    end
  end

  context 'with admin role' do
    let(:user) { create(:user) }

    before { user.add_role(:admin, organization) }

    it { is_expected.to permit_actions(%i[index destroy show create new update edit]) }

    it 'includes donor_account in scope' do
      expect(resolved_scope).to include(donor_account)
    end
  end
end
