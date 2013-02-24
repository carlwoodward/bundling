require "rack/test"
require_relative File.join(File.dirname(__FILE__), "../spec_helper")

describe Bundling::Web do
  include Rack::Test::Methods

  def app
    Bundling::Web.new
  end

  describe "GET /" do
    context "without any gems" do
      it "returns 404" do
        get "/"
        expect(last_response.status).to be 404
      end
    end

    context "with gems and versions" do
      it "returns dependencies" do
        get "/?sinatra=latest&rake=0.9.5"
        expect(last_response.status).to be 200
      end
    end
  end
end
