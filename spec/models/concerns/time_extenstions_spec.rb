# require 'rails_helper'

# describe ActiveSupport::TimeWithZone do
#   # ['Arizona', 'Alaska', 'Indiana (East)', 'Midway Island', 'Hawaii'].each do |tz|
#   ::ActiveSupport::TimeZone.all.map(&:name).each do |tz|
#     context "in #{tz} time zone" do
#       before { Time.zone = tz }

#       describe '.to_next_hour' do
#         it 'returns at time in the same time zone' do
#           t = Time.zone.local(2001, 2, 2, 15, 14, 55)
#           t.to_next_hour.time_zone.should eq(t.time_zone)
#         end

#         it 'next even hour' do
#           t = Time.zone.local(2001, 2, 2, 15, 14, 55)
#           t2 = Time.zone.local(2001, 2, 2, 16, 0, 0)
#           t.to_next_hour.should be_within(1).of(t2)

#           t = Time.zone.local(2001, 2, 2, 15, 0, 1)
#           t2 = Time.zone.local(2001, 2, 2, 16, 0, 0)
#           t.to_next_hour.should be_within(1).of(t2)

#           t = Time.zone.local(2001, 2, 2, 15, 59, 59)
#           t2 = Time.zone.local(2001, 2, 2, 16, 0, 0)
#           t.to_next_hour.should be_within(1).of(t2)
#         end

#         it 'advances to next day' do
#           t = Time.zone.local(2001, 2, 2, 23, 14, 55)
#           t2 = Time.zone.local(2001, 2, 3, 0, 0, 0)
#           t.to_next_hour.should be_within(1).of(t2)

#           t = Time.zone.local(2001, 2, 2, 23, 0, 1)
#           t2 = Time.zone.local(2001, 2, 3, 0, 0, 0)
#           t.to_next_hour.should be_within(1).of(t2)
#         end

#         it 'advances to next year' do
#           t = Time.zone.local(2001, 12, 31, 23, 0, 1)
#           t2 = Time.zone.local(2002, 1, 1, 0, 0, 0)
#           t.to_next_hour.should be_within(1).of(t2)
#         end

#         it 'handles leap years' do
#           t = Time.zone.local(2004, 2, 28, 23, 0, 1)
#           t2 = Time.zone.local(2004, 2, 29, 0, 0, 0)
#           t.to_next_hour.should be_within(1).of(t2)
#         end
#       end

#       describe '.to_next_30_minutes' do
#         it 'returns at time in the same time zone' do
#           t = Time.zone.local(2001, 2, 2, 15, 14, 55)
#           t.to_next_30_minutes.time_zone.should eq(t.time_zone)
#         end

#         it 'next 30 minutes' do
#           t = Time.zone.local(2001, 2, 2, 15, 14, 55)
#           t2 = Time.zone.local(2001, 2, 2, 15, 30, 0)
#           t.to_next_30_minutes.should be_within(1).of(t2)

#           t = Time.zone.local(2001, 2, 2, 15, 0, 1)
#           t2 = Time.zone.local(2001, 2, 2, 15, 30, 0)
#           t.to_next_30_minutes.should be_within(1).of(t2)

#           t = Time.zone.local(2001, 2, 2, 15, 59, 59)
#           t2 = Time.zone.local(2001, 2, 2, 16, 0, 0)
#           t.to_next_30_minutes.should be_within(1).of(t2)
#         end

#         it 'advances to next day' do
#           t = Time.zone.local(2001, 2, 2, 23, 30, 1)
#           t2 = Time.zone.local(2001, 2, 3, 0, 0, 0)
#           t.to_next_30_minutes.should be_within(1).of(t2)
#         end

#         it 'advances to next year' do
#           t = Time.zone.local(2001, 12, 31, 23, 30, 1)
#           t2 = Time.zone.local(2002, 1, 1, 0, 0, 0)
#           t.to_next_30_minutes.should be_within(1).of(t2)
#         end

#         it 'handles leap years' do
#           t = Time.zone.local(2004, 2, 28, 23, 30, 1)
#           t2 = Time.zone.local(2004, 2, 29, 0, 0, 0)
#           t.to_next_30_minutes.should be_within(1).of(t2)
#         end

#       end

#       # describe '.round' do
#         # it 'returns at time in the same time zone' do
#         #   t = Time.zone.local(2001, 2, 2, 15, 14, 55)
#         #   t.round(15.minutes).time_zone.should eq(t.time_zone)
#         # end

#         # it 'to the nearest 15 minutes' do
#         #   t = Time.zone.local(2001, 2, 2, 15, 14, 55)
#         #   t2 = Time.zone.local(2001, 2, 2, 15, 15, 0)
#         #   t.round(15.minutes).should be_within(1).of(t2)
#         # end

#         # it 'to the nearest 30 minutes' do
#         #   t = Time.zone.local(2001, 2, 2, 15, 14, 55)
#         #   t2 = Time.zone.local(2001, 2, 2, 15, 00, 0)
#         #   t.round(30.minutes).should be_within(1).of(t2)

#         #   t = Time.zone.local(2001, 2, 2, 15, 31, 55)
#         #   t2 = Time.zone.local(2001, 2, 2, 15, 30, 0)
#         #   t.round(30.minutes).should be_within(1).of(t2)

#         #   t = Time.zone.local(2001, 2, 2, 15, 45, 01)
#         #   t2 = Time.zone.local(2001, 2, 2, 16, 0, 0)
#         #   t.round(30.minutes).should be_within(1).of(t2)

#         #   t = Time.zone.local(2001, 2, 2, 15, 44, 59)
#         #   t2 = Time.zone.local(2001, 2, 2, 15, 30, 0)
#         #   t.round(30.minutes).should be_within(1).of(t2)
#         # end

#         # it 'to the nearest hour' do
#         #   t = Time.zone.local(2001, 2, 2, 15, 14, 55)
#         #   t2 = Time.zone.local(2001, 2, 2, 15, 00, 0)
#         #   t.round(1.hour).should be_within(1).of(t2)

#         #   t = Time.zone.local(2001, 2, 2, 15, 30, 1)
#         #   t2 = Time.zone.local(2001, 2, 2, 16, 00, 0)
#         #   t.round(1.hour).should be_within(1).of(t2)

#         #   t = Time.zone.local(2001, 2, 2, 15, 0, 1)
#         #   t2 = Time.zone.local(2001, 2, 2, 15, 00, 0)
#         #   t.round(1.hour).should be_within(1).of(t2)
#         # end

#         # it 'to the nearest 2 hours' do
#         #   t = Time.zone.local(2001, 2, 2, 15, 14, 55)
#         #   t2 = Time.zone.local(2001, 2, 2, 15, 0, 0)
#         #   t.round(2.hours).should be_within(1).of(t2)

#         #   t = Time.zone.local(2001, 2, 2, 15, 30, 1)
#         #   t2 = Time.zone.local(2001, 2, 2, 15, 0, 0)
#         #   t.round(2.hours).should be_within(1).of(t2)

#         #   t = Time.zone.local(2001, 2, 2, 15, 0, 1)
#         #   t2 = Time.zone.local(2001, 2, 2, 15, 0, 0)
#         #   t.round(2.hours).should be_within(1).of(t2)
#         # end
#       # end

#       # describe '.ceil' do
#       #   it 'returns at time in the same time zone' do
#       #     t = Time.zone.local(2001, 2, 2, 15, 14, 55)
#       #     t.ceil(15.minutes).time_zone.should eq(t.time_zone)
#       #   end

#       #   it 'to the nearest 15 minutes' do
#       #     t = Time.zone.local(2001, 2, 2, 15, 14, 55)
#       #     t2 = Time.zone.local(2001, 2, 2, 15, 15, 0)
#       #     t.ceil(15.minutes).should be_within(1).of(t2)
#       #   end

#       #   it 'to the nearest 30 minutes' do
#       #     t = Time.zone.local(2001, 2, 2, 15, 14, 55)
#       #     t2 = Time.zone.local(2001, 2, 2, 15, 30, 0)
#       #     # t.ceil(30.minutes).should be_within(1).of(t2)

#       #     t = Time.zone.local(2001, 2, 2, 15, 31, 55)
#       #     t2 = Time.zone.local(2001, 2, 2, 15, 30, 0)
#       #     t.ceil(30.minutes).should be_within(1).of(t2)

#       #     t = Time.zone.local(2001, 2, 2, 15, 45, 01)
#       #     t2 = Time.zone.local(2001, 2, 2, 16, 0, 0)
#       #     t.ceil(30.minutes).should be_within(1).of(t2)

#       #     t = Time.zone.local(2001, 2, 2, 15, 44, 59)
#       #     t2 = Time.zone.local(2001, 2, 2, 15, 30, 0)
#       #     t.ceil(30.minutes).should be_within(1).of(t2)
#       #   end

#       #   it 'to the nearest hour' do
#       #     t = Time.zone.local(2001, 2, 2, 15, 14, 55)
#       #     t2 = Time.zone.local(2001, 2, 2, 15, 00, 0)
#       #     t.ceil(1.hour).should be_within(1).of(t2)

#       #     t = Time.zone.local(2001, 2, 2, 15, 30, 1)
#       #     t2 = Time.zone.local(2001, 2, 2, 16, 00, 0)
#       #     t.ceil(1.hour).should be_within(1).of(t2)

#       #     t = Time.zone.local(2001, 2, 2, 15, 0, 1)
#       #     t2 = Time.zone.local(2001, 2, 2, 15, 00, 0)
#       #     t.ceil(1.hour).should be_within(1).of(t2)
#       #   end

#         # it 'to the nearest 2 hours' do
#         #   t = Time.zone.local(2001, 2, 2, 15, 14, 55)
#         #   t2 = Time.zone.local(2001, 2, 2, 15, 0, 0)
#         #   t.ceil(2.hours).should be_within(1).of(t2)

#         #   t = Time.zone.local(2001, 2, 2, 15, 30, 1)
#         #   t2 = Time.zone.local(2001, 2, 2, 15, 0, 0)
#         #   t.ceil(2.hours).should be_within(1).of(t2)

#         #   t = Time.zone.local(2001, 2, 2, 15, 0, 1)
#         #   t2 = Time.zone.local(2001, 2, 2, 15, 0, 0)
#         #   t.ceil(2.hours).should be_within(1).of(t2)
#         # end
#       # end
#     end
#   end
# end
