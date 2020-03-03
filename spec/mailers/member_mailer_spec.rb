# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MemberMailer, type: :mailer do
  let(:member) { create(:member) }

  describe '#inform' do
    subject!(:mail) { described_class.inform(member) }

    it 'renders the subject' do
      expect(mail.subject).to eq 'Sign into MPDX using your donation services credentials'
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([member.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['no-reply@donationcore.com'])
    end
  end
end
