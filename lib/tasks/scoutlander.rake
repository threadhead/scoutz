VCR.configure do |c|
  c.cassette_library_dir = 'tmp/vcr'
  c.hook_into :webmock
  c.filter_sensitive_data('<SCOUTLANDER_PASSWORD>') { ENV['SCOUTLANDER_PASSWORD'] }
  c.default_cassette_options = { record: :new_episodes }
end


namespace :scoutlander do
  desc "import troop 603"
  task :import_troop_603 => [:environment] do
    unit = Unit.find_by_unit_number('603')

    # # scrape and import sub units
    # sub_unit_importer = Scoutlander::Importer::SubUnits.new(
    #                             email: 'threadhead@gmail.com',
    #                             password: ENV['SCOUTLANDER_PASSWORD'],
    #                             unit: unit
    #                             )

    # sub_unit_importer.fetch_sub_units
    # sub_unit_importer.sub_units.each do |sub_unit|
    #   unit.sub_units.create(sub_unit.to_params)
    # end



    # # scrape and import scouts
    # scout_importer = Scoutlander::Importer::Scouts.new(
    #                     email: 'threadhead@gmail.com',
    #                     password: ENV['SCOUTLANDER_PASSWORD'],
    #                     unit: unit
    #                     )

    # scout_importer.fetch_unit_scouts
    # scout_importer.fetch_all_scout_info_and_create



    # # scrape and import adults
    # adult_importer = Scoutlander::Importer::Adults.new(
    #                     email: 'threadhead@gmail.com',
    #                     password: ENV['SCOUTLANDER_PASSWORD'],
    #                     unit: unit
    #                     )

    # adult_importer.fetch_unit_adults
    # adult_importer.fetch_all_adult_info_and_create


    # scrape and import events and signups
    event_importer = Scoutlander::Importer::Events.new(
                        email: 'threadhead@gmail.com',
                        password: ENV['SCOUTLANDER_PASSWORD'],
                        unit: unit
                        )

    VCR.use_cassette('fetch_unit_events') { event_importer.fetch_unit_events }
    VCR.use_cassette('fetch_all_event_info_and_create') { event_importer.fetch_all_event_info_and_create }
  end
end
