# frozen_string_literal: true

# == Schema Information
#
# Table name: organizations
#
#  id         :uuid             not null, primary key
#  code       :string
#  email      :string
#  name       :string
#  subdomain  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_organizations_on_subdomain  (subdomain) UNIQUE
#
require 'rails_helper'

RSpec.describe Organization, type: :model do
  it { is_expected.to have_many(:designation_accounts).dependent(:destroy) }
  it { is_expected.to have_many(:donations).through(:designation_accounts) }
  it { is_expected.to have_many(:donor_accounts).dependent(:destroy) }
  it { is_expected.to have_many(:integrations).dependent(:destroy) }
  it { is_expected.to have_many(:members).dependent(:destroy) }
  it { is_expected.to have_many(:users).dependent(:destroy) }
  it { is_expected.to validate_presence_of(:subdomain) }
  it { is_expected.to allow_value('my-sub-domain').for(:subdomain) }
  it { is_expected.not_to allow_value('test--domain-').for(:subdomain) }

  describe '#minimum_donation_date' do
    subject(:organization) { create(:organization) }

    it 'returns 1/1/1970' do
      expect(organization.minimum_donation_date).to eq '01/01/1970'
    end

    context 'when donations exist' do
      let(:designation_account) { create(:designation_account, organization: organization) }
      let(:donor_account) { create(:donor_account, organization: organization) }

      before do
        create(
          :donation, designation_account: designation_account, donor_account: donor_account, created_at: 1.year.ago
        )
        create(
          :donation, designation_account: designation_account, donor_account: donor_account, created_at: 1.month.ago
        )
      end

      it 'returns oldest donation date' do
        expect(organization.minimum_donation_date).to eq 1.year.ago.strftime('%m/%d/%Y')
      end
    end
  end

  describe '#update_subdomain' do
    subject(:organization) { build(:organization, subdomain: subdomain) }

    let(:subdomain) { 'test' }

    it 'enqueues an add job' do
      expect { organization.save }.to have_enqueued_job(Organization::SubdomainJob).with(subdomain, 'add')
    end

    context 'when updating subdomain' do
      subject(:organization) { create(:organization, subdomain: subdomain) }

      it 'enqueues a remove job' do
        expect { organization.update(subdomain: 'no') }.to(
          have_enqueued_job(Organization::SubdomainJob).with(subdomain, 'remove')
        )
      end
    end
  end
end
