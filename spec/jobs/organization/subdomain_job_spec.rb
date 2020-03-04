# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization::SubdomainJob, type: :job do
  subject(:job) { described_class.perform_later(host, action) }

  let(:subdomain) { attributes_for(:organization)[:subdomain] }
  let(:host) { "#{subdomain}.#{ENV.fetch('DOMAIN_NAME')}" }
  let(:action) { 'add' }

  it 'queues the job' do
    expect { job }.to have_enqueued_job(described_class).with(host, action).on_queue('default')
  end

  describe '#perform' do
    subject(:job) { described_class.new }

    let(:platform_api_domain) { instance_double(PlatformAPI::Domain) }

    before do
      allow(PlatformAPI::Domain).to receive(:new).and_return(platform_api_domain)
    end

    it 'calls create' do
      allow(platform_api_domain).to receive(:create)
      job.perform(subdomain, action)
      expect(platform_api_domain).to have_received(:create).with('donation-core', 'hostname' => host)
    end

    context 'when API returns UnprocessableEntity error' do
      it 'calls Rollbar' do
        allow(platform_api_domain).to receive(:create).and_raise(Excon::Error::UnprocessableEntity, 'message')
        allow(Rollbar).to receive(:error)
        job.perform(subdomain, action)
        expect(Rollbar).to have_received(:error)
      end
    end

    context 'when action is remove' do
      let(:action) { 'remove' }

      it 'calls delete' do
        allow(platform_api_domain).to receive(:delete)
        job.perform(subdomain, action)
        expect(platform_api_domain).to have_received(:delete).with('donation-core', host)
      end
    end
  end
end
