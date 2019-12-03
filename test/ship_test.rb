require_relative 'test_helper'
require_relative '../lib/ship'

class ShipTest < Minitest::Test
  def setup
    @cruiser = Ship.new("Cruiser", 3)
  end

  def test_cruiser_is_a_ship
    assert_instance_of Ship, @cruiser
  end

  def test_ship_has_attributes
    assert_equal "Cruiser", @cruiser.name
    assert_equal 3, @cruiser.ship_length
    assert_equal 3, @cruiser.health
  end

  def test_ship_is_not_sunk_by_default
    assert_equal false, @cruiser.sunk?
  end

  def test_ship_can_be_hit
    @cruiser.hit

    assert_equal 2, @cruiser.health
    assert_equal false, @cruiser.sunk?
  end

  def test_ship_can_be_sunk_from_hits
    @cruiser.hit
    @cruiser.hit

    assert_equal 1, @cruiser.health
    assert_equal false, @cruiser.sunk?

    @cruiser.hit

    assert_equal 0, @cruiser.health
    assert_equal true, @cruiser.sunk?
  end
end