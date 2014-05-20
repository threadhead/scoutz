FactoryGirl.define do

  factory :home_phone do
    kind     "Home"
    number   "480-555-1212"
   end
  factory :work_phone do
    kind     "Work"
    number   "312-555-1212"
   end
  factory :mobile_phone do
    kind     "Mobile"
    number   "602-555-1212"
   end
end
