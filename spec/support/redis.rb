RSpec.configure do |config|
  config.after(:each) do
    $redis.flushdb
  end
end
