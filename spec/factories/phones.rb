FactoryGirl.define do

  factory :home_phone, class: Phone do
    kind     'home'
    number   '480-555-1212'
  end

  factory :work_phone, class: Phone do
    kind     'work'
    number   '312-555-1212'
  end

  factory :mobile_phone, class: Phone do
    kind     'mobile'
    number   '602-555-1212'
  end
end
