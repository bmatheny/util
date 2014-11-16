require 'rubygems' if RUBY_VERSION.to_f < 1.9

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec::configure do |c|

  c.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  c.mock_with :rspec do |mocks|
    mocks.syntax = :expect
  end

end
