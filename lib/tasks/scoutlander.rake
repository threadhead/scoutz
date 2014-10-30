begin
    VCR.configure do |c|
      c.cassette_library_dir = 'tmp/vcr'
      c.hook_into :webmock
      c.filter_sensitive_data('<SCOUTLANDER_PASSWORD>') { ENV['SCOUTLANDER_PASSWORD'] }
      c.default_cassette_options = { record: :new_episodes }

      c.ignore_hosts 'scouttin-dev.s3.amazonaws.com', 'scouttin.s3.amazonaws.com'
    end


    namespace :scoutlander do
      desc "import troop 603"
      task :import_troop_603_vcr => [:environment] do
        WebMock.enable! # disabled in development.rb
        unit = Unit.find_or_create_by(unit_number: '603') do |u|
          u.unit_type = 'Boy Scouts'
          u.city = 'Scottsdale'
          u.state = 'AZ'
          u.time_zone = 'Arizona'
        end
        unit.update_attributes(sl_uid: '3218')


        # # scrape and import sub units
        sub_unit_importer = Scoutlander::Importer::SubUnits.new(
                                    email: 'threadhead@gmail.com',
                                    password: ENV['SCOUTLANDER_PASSWORD'],
                                    unit: unit
                                    )

        VCR.use_cassette('fetch_sub_units') { sub_unit_importer.fetch_sub_units }
        sub_unit_importer.sub_units.each do |sub_unit|
          unit.sub_units.create(sub_unit.to_params)
        end



        # # scrape and import scouts
        scout_importer = Scoutlander::Importer::Scouts.new(
                            email: 'threadhead@gmail.com',
                            password: ENV['SCOUTLANDER_PASSWORD'],
                            unit: unit,
                            disable_all_notifications: false
                            )

        VCR.use_cassette('fetch_unit_persons(:scout)') { scout_importer.fetch_unit_scouts }
        VCR.use_cassette('fetch_all_scout_info_and_create') { scout_importer.fetch_all_scout_info_and_create }



        # # scrape and import adults
        adult_importer = Scoutlander::Importer::Adults.new(
                            email: 'threadhead@gmail.com',
                            password: ENV['SCOUTLANDER_PASSWORD'],
                            unit: unit,
                            disable_all_notifications: false
                            )

        VCR.use_cassette('fetch_unit_persons(:adult)') { adult_importer.fetch_unit_adults }
        VCR.use_cassette('fetch_all_adult_info_and_create') { adult_importer.fetch_all_adult_info_and_create }


        # scrape and import events and signups
        event_importer = Scoutlander::Importer::Events.new(
                            email: 'threadhead@gmail.com',
                            password: ENV['SCOUTLANDER_PASSWORD'],
                            unit: unit
                            )

        VCR.use_cassette('fetch_unit_events') { event_importer.fetch_unit_events }
        VCR.use_cassette('fetch_all_event_info_and_create') { event_importer.fetch_all_event_info_and_create }

        pass = {password: 'pack1134', password_confirmation: 'pack1134', confirmed_at: 1.day.ago}
        Adult.where(email: 'threadhead@gmail.com').first.update_attributes(pass)
        Adult.where(email: 'rob@robmadden.com').first.update_attributes(pass)
        Adult.where(email: 'tasst01@hotmail.com').first.update_attributes(pass)
        user = Adult.where(email: 'stoya.robert@orbital.com').first

        # add rob stoya to the unit
        if user
          user.update_attributes(pass)
          unless unit.users.where(id: user.id).exists?
            user.units << unit
          end
        end

      end
    end
rescue NameError
    #no VCR
end
