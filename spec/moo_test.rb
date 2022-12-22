require 'minitest/autorun'
require 'rack/test' 
require_relative '../doombot_controller'
class MooTest < Minitest::Test
  include Rack::Test::Methods

  def test_moo
    assert_equal 'Moo', 'Moo'
  end
end