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

  def test_cell_can_pass_ship_hit
    @cell.place_ship(@cruiser)

    assert_equal false, @cell.fired_upon?

    @cell.fire_upon

    assert_equal 2, @cell.ship.health
    assert_equal true, @cell.fired_upon?
  end

  def test_cell_ship_render_empty_hit_sunk
    assert_equal ".", @cell.render

    @cell.place_ship(@cruiser)

    @cell.fire_upon

    assert_equal "H", @cell.render

    @cell.fire_upon
    @cell.fire_upon

    assert_equal "X", @cell.render
    assert_equal true, @cell.ship.sunk?
  end

  def test_cell_can_be_missed
    @cell.fire_upon

    assert_equal "M", @cell.render
  end

  def test_cell_will_show_ship_if_true
    assert_equal ".", @cell.render
    @cell.place_ship(@cruiser)
    assert_equal "S", @cell.render(true)

    @cell.fire_upon

    assert_equal "H", @cell.render

  end
end
