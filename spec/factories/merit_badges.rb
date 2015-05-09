# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :merit_badge do
    name            'Engineering'
    eagle_required  true
  end
end
