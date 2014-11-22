require 'rubygems' if RUBY_VERSION.to_f < 1.9

require 'broomutil'
# FIXME because LogManager resets Logging, it breaks the logging_helper. Uncomming the
# require/include and capture_log_messages to see
# require 'rspec/logging_helper'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec::configure do |c|
  # include RSpec::LoggingHelper

  c.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  c.mock_with :rspec do |mocks|
    mocks.syntax = :expect
  end

  BroomUtil::Logging.configure('root').level(:error)

  # c.capture_log_messages
end
