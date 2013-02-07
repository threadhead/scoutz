FactoryGirl.define do

  factory :unit do
    unit_type     "Cub Scouts"
    unit_number   "134"
    city          { Faker::AddressUS.city }
    state         { Faker::AddressUS.state }
    time_zone     "Arizona"
   end
end
