namespace :scoutlander do
  desc "import Troop 603"
  task import_troop_603: [:environment] do
    find_or_create_unit
    params = {
               email: 'threadhead@gmail.com',
               password: ENV['SCOUTLANDER_PASSWORD'],
               unit: @unit,
               vcr: false
              }
    import_unit
    set_users
  end
end


# we wrap this section in a begin/end so that it doesn't register with rake if VCR/WebMock are not available
begin
    VCR.configure do |c|
      c.cassette_library_dir = 'tmp/vcr'
      c.hook_into :webmock
      c.filter_sensitive_data('<SCOUTLANDER_PASSWORD>') { ENV['SCOUTLANDER_PASSWORD'] }
      c.default_cassette_options = { record: :new_episodes }

      c.ignore_hosts 'scouttin-dev.s3.amazonaws.com', 'scouttin.s3.amazonaws.com'
    end

    namespace :scoutlander do
      desc "import troop 603 using VCR"
      task import_troop_603_vcr: [:environment] do
        WebMock.enable! # disabled in development.rb
        find_or_create_unit
        params = {
                   email: 'threadhead@gmail.com',
                   password: ENV['SCOUTLANDER_PASSWORD'],
                   unit: @unit,
                   vcr: true
                  }

        import_unit(params)
        set_users
      end
    end
rescue NameError
    #no VCR
end




def find_or_create_unit
  @unit = Unit.find_or_create_by(unit_number: '603') do |u|
    u.unit_type = 'Boy Scouts'
    u.city = 'Scottsdale'
    u.state = 'AZ'
    u.time_zone = 'Arizona'
  end
  @unit.update_attributes(sl_uid: '3218')
end


def import_unit(params)
  # scrape and import sub units
  Scoutlander::Importer::SubUnits.new(params).perform

  # scrape and import scouts
  Scoutlander::Importer::Scouts.new(params).perform

  # scrape and import adults
  Scoutlander::Importer::Adults.new(params).perform

  # scrape and import events and signups
  Scoutlander::Importer::Events.new(params).perform
end


def set_users
  pass = {password: 'pack1134', password_confirmation: 'pack1134', confirmed_at: 1.day.ago}
  Adult.where(email: 'threadhead@gmail.com').first.update_attributes(pass)
  Adult.where(email: 'rob@robmadden.com').first.update_attributes(pass)
  Adult.where(email: 'tasst01@hotmail.com').first.update_attributes(pass)
  user = Adult.where(email: 'stoya.robert@orbital.com').first

  # add rob stoya to the unit
  if user
    user.update_attributes(pass)
    unless @unit.users.where(id: user.id).exists?
      user.units << @unit
    end
  end
end

