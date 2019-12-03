require_relative 'test_helper'
require_relative '../lib/cell'
require_relative "../lib/ship"

class CellTest < MiniTest::Test
  def setup
    @cell = Cell.new("B4")
    @cruiser = Ship.new("Cruiser", 3)
  end

  def test_is_instance_of_cell
    assert_instance_of Cell, @cell
  end

  def test_cell_has_attributes
    assert_equal "B4", @cell.coordinate
    assert_nil @cell.ship
  end

  def test_cell_is_empty_to_start
    assert_equal true, @cell.empty?
  end

  def test_can_take_in_ship
    @cell.place_ship(@cruiser)

    assert_equal @cruiser, @cell.ship
    assert_equal false, @cell.empty?
  end
end
