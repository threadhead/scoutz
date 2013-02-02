FactoryGirl.define do
  sequence :user_email do |n|
    "threadhead#{n}@gmail.com"
  end

  factory :user do
    email               { FactoryGirl.generate(:user_email)}
    password            "sekritsekrit"

    first_name          "Karl"
    last_name           "Smith"
    address1            "6730 Boulder Court South"
    city                "Indianapolis"
    state               "IN"
    zip_code            "46217"
  end
end
