require_relative File.join(File.dirname(__FILE__), "../spec_helper")

describe Bundling::DependencyGenerator do
  let(:name) { "sinatra" }
  let(:version) { "latest" }
  let(:dependency_generator) { Bundling::DependencyGenerator.new name, version }

  describe "#nested_dependencies" do
    context "when the gem can't be found" do
      let(:name) { "unknown" }

      it "throws an exception" do
        expect { dependency_generator.nested_dependencies }.to raise_error(Bundling::GemNotFoundError)
      end
    end

    context "when the gem can be found" do
      it "returns a list of gems and their dependencies" do
        expect(dependency_generator.nested_dependencies.flatten).to have_at_least(3).dependencies
      end
    end
  end

  describe "#fetch_version" do
    let(:body) do
      [
        {"name" => "rack-protection", "number" => "1.4.0", "platform" => "ruby", "dependencies" => [["rack", ">= 0"]]},
        {"name" => "rack-protection", "number" => "1.3.2", "platform" => "ruby", "dependencies" => [["rack", ">= 0"]]}
      ]
    end

    context "when latest" do
      it "returns the first version" do
        expect(dependency_generator.fetch_version(body)).to eq body.first
      end
    end

    context "when specific version" do
      let(:version) { "1.3.2" }
      it "returns the row with that version" do
        expect(dependency_generator.fetch_version(body)).to eq body.last
      end
    end
  end

  describe "#dependency_url" do
    it "returns the dependency url with the gem" do
      expect(dependency_generator.dependency_url(name)).to include("/dependencies")
    end
  end

  describe "#connection" do
    it "returns a faraday connection" do
      expect(dependency_generator.connection).to be_a(Faraday::Connection)
    end
  end
end
