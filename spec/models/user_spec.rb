# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  admin                  :boolean          default("false")
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default("0"), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

describe User do
  subject(:user) { create(:user, email: 'user@example.com') }

  it { is_expected.to belong_to(:organization) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_confirmation_of(:password) }
  it { is_expected.to validate_length_of(:password) }

  describe '#email' do
    it 'returns a string' do
      expect(user.email).to match 'user@example.com'
    end
  end

  describe '.find_for_authentication' do
    let(:conditions) { { email: Faker::Internet.email, subdomain: Faker::Internet.domain_word } }

    it 'returns nil' do
      expect(described_class.find_for_authentication(conditions)).to eq nil
    end

    context 'when user exists' do
      subject!(:user) do
        create(
          :user,
          email: conditions[:email],
          organization: create(:organization, subdomain: conditions[:subdomain])
        )
      end

      it 'returns user' do
        expect(described_class.find_for_authentication(conditions)).to eq user
      end
    end
  end
end
