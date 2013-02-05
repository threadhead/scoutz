FactoryGirl.define do
  sequence :user_email do |n|
    "threadhead#{n}@gmail.com"
  end

  factory :user do
    email               { FactoryGirl.generate(:user_email)}
    password            "sekritsekrit"
    confirmed_at        { 1.day.ago }

    first_name          "Karl"
    last_name           "Smith"
    address1            "6730 Boulder Court South"
    city                "Indianapolis"
    state               "IN"
    zip_code            "46217"
  end
end
