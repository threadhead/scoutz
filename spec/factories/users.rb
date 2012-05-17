FactoryGirl.define do
  
  factory :user do
    email               {Faker::Internet.email}
    password            "sekritsekrit"

    first_name          {Faker::Name.first_name}
    last_name           {Faker::Name.last_name}
    address1            {Faker::AddressUS.street_address}
    city                {Faker::AddressUS.city}
    state               {Faker::AddressUS.state}
    zip_code            {Faker::AddressUS.zip_code}
  end
end
