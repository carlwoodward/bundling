require "rspec/core"
require_relative File.join(File.dirname(__FILE__), "../lib/bundling")

ENV["RACK_ENV"] = "test"

RSpec.configure do |config|
  config.alias_example_to :fit, :focused => true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
