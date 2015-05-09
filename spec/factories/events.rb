FactoryGirl.define do
  factory :event do
    name        'USS Midway Overnight'
    kind        'Pack Event'
    start_at    { 3.days.from_now }
    end_at      { start_at + 2.hours }
    message     'I am a message. Please send me.'
  end
end
