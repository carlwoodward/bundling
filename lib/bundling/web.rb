require "sinatra/base"

module Bundling
  class Web < Sinatra::Base
    get "/" do
      if params.any?
        status 200
      else
        not_found
      end
    end
  end
end
