# speed up tests
CarrierWave.configure do |config|
  config.storage = :file
  config.enable_processing = !(Rails.env.test? or Rails.env.cucumber?)
end
