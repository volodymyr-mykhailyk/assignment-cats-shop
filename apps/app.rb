require 'sinatra/base'
require_relative 'routes/landing'

module CatsShop
  class App < Sinatra::Application
    configure do
      disable :method_override
      disable :static
    end

    use CatsShop::Routes::Landing
  end
end