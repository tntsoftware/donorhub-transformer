require "csv"

CSV.generate do |csv|
  headers = %w(
    PEOPLE_ID
    ACCT_NAME
    DISPLAY_DATE
    AMOUNT
    DONATION_ID
    DESIGNATION
    MOTIVATION
    PAYMENT_METHOD
    MEMO
    TENDERED_AMOUNT
    TENDERED_CURRENCY
    ADJUSTMENT_TYPE
  )

  csv << headers

  @donations.each do |donation|
    csv << [
      donation.donor_account_id,                # PEOPLE_ID
      donation.donor_account.name,              # ACCT_NAME
      donation.created_at.strftime("%m/%d/%Y"), # DISPLAY_DATE
      donation.amount,                          # AMOUNT
      donation.id,                              # DONATION_ID
      donation.designation_account_id,          # DESIGNATION
      "",                                       # MOTIVATION
      "",                                       # PAYMENT_METHOD
      "",                                       # MEMO
      donation.amount,                          # TENDERED_AMOUNT
      donation.currency,                        # TENDERED_CURRENCY
      "",                                       # ADJUSTMENT_TYPE
    ]
  end
end
