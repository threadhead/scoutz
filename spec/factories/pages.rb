# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :page do
    postion 1
    title "MyString"
    body "MyText"
    unit nil
    user nil
    public false
  end
end
