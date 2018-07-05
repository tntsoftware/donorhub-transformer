FactoryBot.define do
  factory :user_permission, class: "User::Permission" do
    user nil
    designation_profile nil
  end
end
