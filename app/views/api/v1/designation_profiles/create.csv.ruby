require "csv"

CSV.generate do |csv|
  headers = %w(
    PROFILE_CODE
    PROFILE_DESCRIPTION
    PROFILE_ACCOUNT_REPORT_URL
  )

  csv << headers

  @designation_profiles.each do |designation_profile|
    csv << [
      designation_profile.id,   # PROFILE_CODE
      designation_profile.name, # PROFILE_DESCRIPTION
      "",                       # PROFILE_ACCOUNT_REPORT_URL
    ]
  end
end
