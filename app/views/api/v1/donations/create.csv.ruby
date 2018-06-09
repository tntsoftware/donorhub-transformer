require "csv"
CSV.generate do |csv|
  headers = %w[PEOPLE_ID ACCT_NAME DISPLAY_DATE AMOUNT DONATION_ID DESIGNATION MOTIVATION
               PAYMENT_METHOD MEMO TENDERED_AMOUNT TENDERED_CURRENCY ADJUSTMENT_TYPE]
  csv << headers
  @donations.each do |donation|
    csv << [donation.donor_account_id,
            donation.donor_account.name,
            donation.created_at.strftime("%m/%d/%Y"),
            donation.amount,
            donation.id,
            donation.designation_account_id,
            "",
            "",
            "",
            donation.amount,
            donation.currency,
            ""]
  end
end
