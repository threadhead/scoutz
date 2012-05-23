namespace :scoutlander do
  desc "import sub_units"
  task :import_sub_units => [:environment] do
    sl = Scoutlander.new('monster@gmail.com', 'sekrit')
    sl.import_sub_units
  end
end