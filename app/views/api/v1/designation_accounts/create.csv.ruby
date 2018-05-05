require 'csv'
CSV.generate do |csv|
  headers = %w[DESIG_ID DESIG_NAME ORG_PATH]
  csv << headers
  @designation_accounts.each do |designation_account|
    csv << [designation_account.id, designation_account.name, '']
  end
end
