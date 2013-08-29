FactoryGirl.define do

  factory :email_message do
    subject    'Email Test Message Subject'
    message    '<h1>Email Test Message</h1><p>lorem and stuff</p>'
  end
end
