require 'minitest/autorun'
require 'rack/test' 
require_relative '../doombot_controller'
class DoombotIntegrationTest < Minitest::Test
  include Rack::Test::Methods

  def test_moo
    get '/'
    assert_equal 'Moo', last_response.body
  end

  def app
    DoombotController
  end
end