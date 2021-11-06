# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DonationPolicy do
  subject(:policy) { described_class.new(user, donation) }

  let(:organization) { create(:organization) }
  let(:user) { create(:user) }
  let!(:donation) { create(:donation, organization: organization, designation_account: designation_account) }
  let!(:designation_account) { create(:designation_account, organization: organization) }

  let(:resolved_scope) do
    described_class::Scope.new(user, organization.donations).resolve
  end

  it { is_expected.to permit_actions(%i[index]) }
  it { is_expected.to forbid_actions(%i[create new show update edit destroy]) }

  it 'excludes donation in scope' do
    expect(resolved_scope).not_to include(donation)
  end

  context 'with member role' do
    let(:user) { create(:user) }

    before { user.add_role(:member, organization) }

    it { is_expected.to permit_actions(%i[index]) }
    it { is_expected.to forbid_actions(%i[create new show update edit destroy]) }

    it 'excludes donation in scope' do
      expect(resolved_scope).not_to include(donation)
    end
  end

  context 'with designation_profile' do
    before do
      user.add_role(:member, organization)
      create(
        :designation_profile,
        designation_account: designation_account,
        member: organization.members.find_by(user: user)
      )
    end

    it { is_expected.to permit_actions(%i[index show]) }
    it { is_expected.to forbid_actions(%i[create new update edit destroy]) }

    it 'includes donation in scope' do
      expect(resolved_scope).to include(donation)
    end
  end

  context 'with admin role' do
    let(:user) { create(:user) }

    before { user.add_role(:admin, organization) }

    it { is_expected.to permit_actions(%i[index destroy show create new update edit]) }

    it 'includes donation in scope' do
      expect(resolved_scope).to include(donation)
    end
  end
end
