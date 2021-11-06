# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationPolicy do
  subject(:policy) { described_class.new(user, organization) }

  let(:organization) { create(:organization) }
  let(:user) { create(:user) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Organization.all).resolve
  end

  it { is_expected.to permit_actions(%i[index create new]) }
  it { is_expected.to forbid_actions(%i[show update edit destroy]) }

  it 'excludes organization in scope' do
    expect(resolved_scope).not_to include(organization)
  end

  context 'with member role' do
    let(:user) { create(:user) }

    before { user.add_role(:member, organization) }

    it { is_expected.to permit_actions(%i[index create new show]) }
    it { is_expected.to forbid_actions(%i[update edit destroy]) }

    it 'includes organization in scope' do
      expect(resolved_scope).to include(organization)
    end
  end

  context 'with admin role' do
    let(:user) { create(:user) }

    before { user.add_role(:admin, organization) }

    it { is_expected.to permit_actions(%i[index create new update edit destroy show]) }

    it 'includes organization in scope' do
      expect(resolved_scope).to include(organization)
    end
  end
end
