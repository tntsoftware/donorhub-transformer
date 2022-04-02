# frozen_string_literal: true

class MemberMailer < ApplicationMailer
  def inform(member)
    @member = member
    mail to: @member.email,
      subject: "Sign into MPDX using your donation services credentials"
  end
end
