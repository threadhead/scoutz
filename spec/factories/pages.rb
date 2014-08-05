# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :page do
    title     "Hippety Page"
    body      "<h1>MyText</h1>"
    public    false
  end
end
