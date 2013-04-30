# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

def log_item(resource, indent=0)
  puts "#{' ' * indent}#{resource.class.name}: #{resource.name if resource.respond_to?(:name)}"
end

unit1 = Unit.create(unit_type: 'Cub Scouts', unit_number: '134', city: 'Cave Creek', state: 'AZ', time_zone: 'Arizona')
log_item(unit1)

unit2 = Unit.create(unit_type: 'Boy Scouts', unit_number: '603', city: 'Scottsdale', state: 'AZ', time_zone: 'Arizona')
log_item(unit2)


user1 = Adult.create({email: 'threadhead@gmail.com', password: 'pack1134', first_name: 'Karl', last_name: 'Smith', time_zone: 'Arizona', confirmed_at: 1.day.ago}, without_protection: true)
log_item(user1, 2)

scout1 = Scout.create(first_name: 'Aydan', last_name: 'Smith', time_zone: 'Arizona', birth: '2002-12-19'.to_date, rank: 'Webelos I')
log_item(scout1, 4)

scout2 = Scout.create(email: 'bennett9918@gmail.com', first_name: 'Bennett', last_name: 'Smith', time_zone: 'Arizona', rank: 'Tenderfoot', birth: '2001-07-20'.to_date, leadership_position: 'Chaplain Aide')
log_item(scout2, 4)
user1.scouts << [scout1, scout2]



user2 = Adult.create({email: 'rob@robmadden.com', password: 'pack1134', first_name: 'Rob', last_name: 'Madden', time_zone: 'Arizona', confirmed_at: 1.day.ago}, without_protection: true)
log_item(user2, 2)

scout3 = Scout.create(first_name: 'Matthew', last_name: 'Madden', time_zone: 'Arizona', birth: '2002-02-02'.to_date, rank: 'Webelos I')
log_item(scout3, 4)
user2.scouts << scout3

user1.units << unit1
user1.units << unit2
user2.units << unit1
scout1.units << unit1
scout2.units << unit2
scout3.units << unit1

6.times do |idx|
  su = SubUnit.create(name: "Den #{idx+1}")
  log_item(su, 2)

  unit1.sub_units << su
  su.scouts << scout1 if idx == 0
  su.scouts << scout3 if idx == 0
end

5.times do |idx|
  su = SubUnit.create(name: "Patrol #{idx+1}")
  log_item(su, 2)

  unit2.sub_units << su
  su.scouts << scout2 if idx == 0
end


def random_rank(unit)
  unit.ranks[rand(unit.ranks.size)]
end

def random_sub_unit(unit)
  unit.sub_units[rand(unit.sub_units.size)]
end

# Add some more fake adults and Cub Scouts
['Mary Smith', 'Marty Black', 'Chris Masters', 'Juan Lopez', 'Frank Jones', 'Tommy Schlame', 'Mel Torme', 'Bill Withers', 'Clyde Cycle', 'Marilyn Manson', 'Bob Barnacle', 'Gene Snow', 'Cavlin Cooper'].each_with_index do |name, idx|
  fname = name.split(' ').first
  lname = name.split(' ').last
  userX = Adult.create({email: "#{name.parameterize}@aol.com", password: 'pack1134', first_name: fname, last_name: lname, time_zone: 'Arizona', confirmed_at: 1.day.ago}, without_protection: true)
  log_item(userX, 2)

  userX.units << unit1

  ['Joey', 'Biff'].each do |scout|
    scoutX = Scout.create(first_name: scout, last_name: lname, time_zone: 'Arizona', rank: random_rank(unit1), birth: rand(7*365..11*365).days.ago)
    log_item(scoutX, 4)

    scoutX.units << unit1
    userX.scouts << scoutX
    random_sub_unit(unit1).scouts << scoutX
  end
end


# Add some more fake adults and Boy Scouts
['Mark Smith', 'Sara Black', 'Chris Tripp', 'Juan DeNada', 'Frank Castle', 'Mark Tuttle', 'Marshall Moon', 'Franklin Pearce', 'Seamore Butts', 'Gregg Brady', 'Wilma Firestone', 'Rudy Diesel', 'Brad Pitts'].each_with_index do |name, idx|
  fname = name.split(' ').first
  lname = name.split(' ').last
  userX = Adult.create({email: "#{name.parameterize}@aol.com", password: 'pack1134', first_name: fname, last_name: lname, time_zone: 'Arizona', confirmed_at: 1.day.ago}, without_protection: true)
  log_item(userX, 2)

  userX.units << unit2

  ['Chip', 'Mudd'].each do |scout|
    scoutX = Scout.create(first_name: scout, last_name: lname, time_zone: 'Arizona', rank: random_rank(unit2), birth: rand(11*365..17*365).days.ago)
    log_item(scoutX, 4)

    scoutX.units << unit2
    userX.scouts << scoutX
    random_sub_unit(unit2).scouts << scoutX
  end
end





# Cub Scout pack events
['USS Midway Museum', 'Movie Night - Friday the 13th', 'Yummie Pie Eating', 'Masters of Disguise', 'Spring Campout - Payson'].each do |ename|
  date = rand(3..90).days.from_now
  event = Event.create(name: ename, kind: 'Pack Event', start_at: date, end_at: date + rand(30).hours, location_name: 'The New York', location_address1: '3660 N Lake Shore Drive', location_city: 'Chicago', location_state: 'IL', location_zip_code: '60657', message: '<h1>Info about the event!</h1>', signup_required: true, signup_deadline: date.beginning_of_day)
  log_item(event, 8)
  event.save

  unit1.events << event
  user1.events << event

  # add some signups
  rand(5).times do
    unit1_scout_count = unit1.scouts.count
    rnd_scout = unit1.scouts.offset(rand(unit1_scout_count)).first
    event_signup = event.event_signups.create(adults_attending: rand(4), scouts_attending: 1, siblings_attending: rand(2), scout_id: rnd_scout.id)
    event_signup.create_activity :create, unit_id: unit1.id, parameters: {event_id: event.id, scout_id: rnd_scout.id}
    log_item(event_signup, 10)
  end
end


# Cub Scout den events
['Den Meeting', 'Swimming Badge', 'Readyman Pin'].each do |ename|
  date = rand(3..90).days.from_now
  event = Event.create(name: ename, kind: 'Den Event', start_at: date, end_at: date + rand(30).hours, location_name: 'The New York', location_address1: '3660 N Lake Shore Drive', location_city: 'Chicago', location_state: 'IL', location_zip_code: '60657', message: '<h1>Info about the event!</h1>', signup_required: true, signup_deadline: date.beginning_of_day)
  event.save
  log_item(event, 8)

  unit1.events << event
  user2.events << event
  SubUnit.find_by_name('Den 1').events << event
end


# Boy Scout troop events
['Camp Raymond', 'Move Night - Beasts of the Southern Wild', 'Watch Mold Grow', 'The Art of Making Mud Pies', 'Backpack - The Pacific Coast Trail'].each do |ename|
  date = rand(3..90).days.from_now
  event = Event.create(name: ename, kind: 'Troop Event', start_at: date, end_at: date + rand(30).hours, location_name: 'The New York', location_address1: '3660 N Lake Shore Drive', location_city: 'Chicago', location_state: 'IL', location_zip_code: '60657', message: '<h1>Info about the event!</h1>', signup_required: true, signup_deadline: date.beginning_of_day)
  event.save
  log_item(event, 8)

  unit2.events << event
  user1.events << event

  # add some signups
  rand(5).times do
    # unit2_scout_count = unit2.scouts.count
    rnd_scout = unit2.scouts.offset(rand(unit2.scouts.count)).first
    event_signup = event.event_signups.create(adults_attending: rand(4), scouts_attending: 1, siblings_attending: rand(2), scout_id: rnd_scout.id)
    event_signup.create_activity :create, unit_id: unit2.id, parameters: {event_id: event.id, scout_id: rnd_scout.id}
    log_item(event_signup, 10)
  end

end
