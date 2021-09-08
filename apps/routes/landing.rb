module CatsShop
  module Routes
    class Landing < Sinatra::Application
      get '/' do
        revision_file = 'REVISION'
        revision = File.exist?(revision_file) ? File.read('REVISION') : 'unknown'
        "Welcome! This is the best Cats shop in the world! Revision: #{revision}"
      end
    end
  end
end
