# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MemberPolicy do
  subject(:policy) { described_class.new(user, member) }

  let(:organization) { create(:organization) }
  let(:user) { create(:user) }
  let(:member) { create(:member, organization: organization) }

  let(:resolved_scope) do
    described_class::Scope.new(user, organization.members).resolve
  end

  it { is_expected.to forbid_actions(%i[index create new show update edit destroy]) }

  it 'excludes member in scope' do
    expect(resolved_scope).not_to include(member)
  end

  context 'with member role' do
    let(:user) { create(:user) }

    before { user.add_role(:member, organization) }

    it { is_expected.to forbid_actions(%i[index create new show update edit destroy]) }

    it 'excludes member in scope' do
      expect(resolved_scope).not_to include(member)
    end
  end

  context 'with admin role' do
    let(:user) { create(:user) }

    before { user.add_role(:admin, organization) }

    it { is_expected.to permit_actions(%i[index destroy show]) }
    it { is_expected.to forbid_actions(%i[create new update edit]) }

    it 'includes member in scope' do
      expect(resolved_scope).to include(member)
    end
  end
end
