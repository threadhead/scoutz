# require 'rails_helper'

# RSpec.describe Scoutlander do
# 	describe 'find_url' do
# 		it 'should return the uid from a url string' do
# 			sl = Scoutlander::Importer.new('username', 'password')
# 			sl.find_uid('/securesite/welcome.aspx?UID=3218').should eq('3218')
# 			sl.find_uid('/securesite/welcome.aspx?UID=3228').should eq('3228')
# 			sl.find_uid('http://scoutlander.com/securesite/parentmain.aspx?UID=8337&profile=244689').should eq('8337')
# 		end
# 	end

# 	describe Scoutlander::Person do
# 		def person_attribute(attribute)
# 			sl = Scoutlander::Person.new(attribute => 'johnny')
# 			sl.send(attribute).should eq('johnny')
# 			sl.send("#{attribute}=", 'bart')
# 			sl.send(attribute).should eq('bart')
# 		end


# 		%w(first_name last_name unit_number unit_number unit_role security_level email  alt_email event_reminders home_phone work_phone cell_phone street  city  state  zip_code url).each do |attribute|
# 			it "should read/write #{attribute}" do
# 				person_attribute(attribute.to_sym)
# 			end
# 		end
# 	end


# 	describe Scoutlander::Unit do
# 		def unit_attribute(attribute)
# 			sl = Scoutlander::Unit.new(attribute => 'johnny')
# 			sl.send(attribute).should eq('johnny')
# 			sl.send("#{attribute}=", 'bart')
# 			sl.send(attribute).should eq('bart')
# 		end


# 		%w(name uid city state time_zone type number).each do |attribute|
# 			it "should read/write #{attribute}" do
# 				unit_attribute(attribute.to_sym)
# 			end
# 		end
# 	end
# end
