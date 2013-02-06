# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

organization1 = Organization.create(unit_type: 'Cub Scouts', unit_number: '134', city: 'Cave Creek', state: 'AZ', time_zone: 'Arizona')
organization2 = Organization.create(unit_type: 'Boy Scouts', unit_number: '603', city: 'Scottsdale', state: 'AZ', time_zone: 'Arizona')


user1 = Adult.create({email: 'threadhead@gmail.com', password: 'pack1134', first_name: 'Karl', last_name: 'Smith', time_zone: 'Arizona', confirmed_at: 1.day.ago}, without_protection: true)
scout1 = Scout.create(first_name: 'Aydan', last_name: 'Smith', time_zone: 'Arizona')
scout2 = Scout.create(email: 'bennett9918@gmail.com', first_name: 'Bennett', last_name: 'Smith', time_zone: 'Arizona', rank: 'Tenderfoot', leadership_position: 'Chaplain Aide')
user1.scouts << [scout1, scout2]

user2 = Adult.create({email: 'rob@robmadden.com', password: 'pack1134', first_name: 'Rob', last_name: 'Madden', time_zone: 'Arizona', confirmed_at: 1.day.ago}, without_protection: true)
scout3 = Scout.create(first_name: 'Matthew', last_name: 'Madden', time_zone: 'Arizona')
user2.scouts << scout3

user1.organizations << organization1
user1.organizations << organization2
user2.organizations << organization1
scout1.organizations << organization1
scout2.organizations << organization2
scout3.organizations << organization1

6.times do |idx|
  su = SubUnit.create(name: "Den #{idx+1}")
  organization1.sub_units << su
  su.scouts << scout1 if idx == 0
  su.scouts << scout3 if idx == 0
end

5.times do |idx|
  su = SubUnit.create(name: "Patrol #{idx+1}")
  organization2.sub_units << su
  su.scouts << scout2 if idx == 0
end


# Cub Scout pack events
['USS Midway Museum', 'Movie Night - Friday the 13th', 'Yummie Pie Eating', 'Masters of Disguise', 'Spring Campout - Payson'].each do |ename|
  date = (rand(30)+3).days.from_now
  event = Event.create(name: ename, kind: 'Pack Event', start_at: date, end_at: date.end_of_day, location_name: 'The New York', location_address1: '3660 N Lake Shore Drive', location_city: 'Chicago', location_state: 'IL', location_zip_code: '60657', message: '<h1>This is a message!</h1>', signup_required: true, signup_deadline: date.beginning_of_day)

  organization1.events << event
  user1.events << event
end


# Cub Scout den events
['Den Meeting', 'Swimming Badge', 'Readyman Pin'].each do |ename|
  date = (rand(30)+3).days.from_now
  event = Event.create(name: ename, kind: 'Den Event', start_at: date, end_at: date.end_of_day, location_name: 'The New York', location_address1: '3660 N Lake Shore Drive', location_city: 'Chicago', location_state: 'IL', location_zip_code: '60657', message: '<h1>This is a message!</h1>', signup_required: true, signup_deadline: date.beginning_of_day)

  organization1.events << event
  user2.events << event
  SubUnit.find_by_name('Den 1').events << event
end


# Boy Scout troop events
['Camp Raymond', 'Move Night - Beasts of the Southern Wild', 'Watch Mold Grow', 'The Art of Making Mud Pies', 'Backpack - The Pacific Coast Trail'].each do |ename|
  date = (rand(30)+3).days.from_now
  event = Event.create(name: ename, kind: 'Troop Event', start_at: date, end_at: date.end_of_day, location_name: 'The New York', location_address1: '3660 N Lake Shore Drive', location_city: 'Chicago', location_state: 'IL', location_zip_code: '60657', message: '<h1>This is a message!</h1>', signup_required: true, signup_deadline: date.beginning_of_day)

  organization2.events << event
  user1.events << event
end
