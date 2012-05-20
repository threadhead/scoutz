namespace :scoutlander do
  desc "import sub_units"
  task :import_sub_units => [:environment] do
    sl = Scoutlander.new('threadhead@gmail.com', 'n67wg2')
    sl.import_sub_units
  end
end