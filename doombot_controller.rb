require 'sinatra/base'
require_relative 'doombot'
class DoombotController < Sinatra::Base

    get '/' do
      # DoombotRunner.new.shov
      "Moo"
    end

    run! if app_file == $0
end