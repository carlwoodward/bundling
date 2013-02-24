require "rack/test"
require_relative File.join(File.dirname(__FILE__), "../spec_helper")

describe Bundling::Web do
  include Rack::Test::Methods

  def app
    Bundling::Web.new
  end
end
