require_relative 'test_helper'
require_relative '../lib/ship'

class ShipTest < Minitest::Test
  def setup
    @cruiser = Ship.new("Cruiser", 3)
  end

  def test_cruiser_is_a_ship
    assert_instance_of Ship, @cruiser
  end
end