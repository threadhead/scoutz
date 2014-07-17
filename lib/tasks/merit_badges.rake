begin
  VCR.configure do |c|
    c.cassette_library_dir = 'tmp/vcr'
    c.hook_into :webmock
    c.default_cassette_options = { record: :new_episodes }
  end


  namespace :merit_badges do
    desc "import merit badges - use vcr"
    task :import_vcr => [:environment] do
      WebMock.enable! # disabled in development.rb

      mb = MbDotOrg::Importer::MeritBadges.new
      VCR.use_cassette('fetch_merit_badges') { mb.fetch_merit_badges }
    end
  end


rescue NameError
    #no VCR
end

namespace :merit_badges do
  desc "import merit badges"
  task :import => [:environment] do
    mb = MbDotOrg::Importer::MeritBadges.new
    mb.fetch_merit_badges
  end
end
