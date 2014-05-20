namespace :scoutlander do
  desc "import troop 603"
  task :import_troop_603 => [:environment] do
    unit = Unit.find_by_unit_number('603')

    # srape and import sub units
    sub_unit_importer = Scoutlander::Importer::SubUnits.new(
                                email: 'threadhead@gmail.com',
                                password: ENV['SCOUTLANDER_PASSWORD'],
                                unit: unit
                                )

    sub_unit_importer.fetch_sub_units
    sub_unit_importer.sub_units.each do |sub_unit|
      unit.sub_units.create(sub_unit.to_params)
    end


    # scrape and import adults
    adult_importer = Scoutlander::Importer::Adults.new(
                        email: 'threadhead@gmail.com',
                        password: ENV['SCOUTLANDER_PASSWORD'],
                        unit: unit
                        )

    adult_importer.fetch_unit_adults
    adult_importer.fetch_all_adult_info_and_create
  end
end
