require "logger"
require "faraday"
require "faraday_middleware"

module Bundling
  class GemNotFoundError < RuntimeError
  end

  class DependencyGenerator
    attr_reader :name, :version

    def initialize(name, version)
      @name = name
      @version = version
    end

    def nested_dependencies(gem_name = self.name)
      if name == "unknown"
        raise GemNotFoundError.new "Gem: #{name} not found."
      else
        result = fetch_version(connection.get(dependency_url(gem_name)).body)
        [{ result["name"] => result["number"] }] + result["dependencies"].map do |dependency|
          nested_dependencies dependency.first
        end
      end
    end

    def fetch_version(body)
      if version == "latest"
        body.first
      else
        body.detect { |gem_description| gem_description["number"] == version }
      end
    end

    def dependency_url(gem_name)
      "/api/v1/dependencies.json?gems=#{gem_name}"
    end

    def connection
      Faraday.new "https://rubygems.org/" do |connection|
        connection.use FaradayMiddleware::ParseJson, :content_type => "application/json"
        connection.use FaradayMiddleware::FollowRedirects, limit: 20
        connection.use Faraday::Response::RaiseError
        connection.use Faraday::Response::Logger, Logger.new($STDOUT)
        connection.use Faraday::Adapter::NetHttp
      end
    end
  end
end
