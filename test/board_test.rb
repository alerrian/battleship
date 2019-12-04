require_relative 'test_helper'
require_relative '../lib/board'
require_relative '../lib/ship'


class BoardTest < Minitest::Test
  def setup
    @board = Board.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
  end

  def test_a_board_is_a_board
    assert_instance_of Board, @board
  end

  def test_cells_is_a_hash
    assert_instance_of Hash, @board.cells
    assert_instance_of Cell, @board.cells.values[0]
  end

  def test_that_coordinates_are_valid
    assert_equal true, @board.validate_coordinates?("A1")
    assert_equal true, @board.validate_coordinates?("D4")
    assert_equal false, @board.validate_coordinates?("A5")
    assert_equal false, @board.validate_coordinates?("E1")
    assert_equal false, @board.validate_coordinates?("A22")
  end

  def test_ship_and_placement_array_same_size
    cruiser_placement = ["A1", "A2"]
    submarine_placement = ["A2", "A3", "A4"]

    assert_equal false, @board.valid_placement?(@cruiser, cruiser_placement)
    assert_equal false, @board.valid_placement?(@submarine, submarine_placement)
  end

  def test_ship_placement_is_in_consecutive_cells
    #Consecutive based on interaction pattern
    cruiser_placement = ["A1", "A2", "A4"]
    submarine_placement = ["A1", "C1"]
    cruiser_placement2 = ["A1", "A2", "A3"]

    assert_equal false, @board.valid_placement?(@cruiser, cruiser_placement)
    assert_equal false, @board.valid_placement?(@submarine, submarine_placement)
    assert_equal true, @board.valid_placement?(@cruiser, cruiser_placement2)
  end

  def test_placement_cannot_be_diagonal
    assert_equal false, @board.valid_placement?(@cruiser, ["A1", "B2", "C3"])
    assert_equal false, @board.valid_placement?(@submarine, ["C2", "D3"])
  end

  def test_cannot_place_A4_to_B1
    assert_equal false, @board.valid_placement?(@cruiser, ["A4", "B1", "B2"])
  end

  def test_can_place_vertical
    assert_equal true, @board.valid_placement?(@cruiser, ["A4", "B4", "C4"])
  end

  def test_cannot_place_vertical_nonconsecutive_cells
    assert_equal false, @board.valid_placement?(@cruiser, ["A4", "B4", "D4"])
  end

  def test_verticals_all_in_one_column
    assert_equal false, @board.valid_placement?(@cruiser, ["C1", "D1", "A2"])
  end

  def test_ship_can_be_placed_in_cells
    @board.place(@cruiser, ["A1", "A2", "A3"])

    assert_instance_of Cell, @board.cells["A1"]
    assert_instance_of Cell, @board.cells["A2"]
    assert_instance_of Cell, @board.cells["A3"]
    assert_equal @cruiser, @board.cells["A1"].ship
    assert_equal @cruiser, @board.cells["A2"].ship
    assert_equal @cruiser, @board.cells["A3"].ship
    assert @board.cells["A1"].ship == @board.cells["A3"].ship
  end

  def test_that_ships_cannot_overlap
    @board.place(@cruiser, ["A1", "A2", "A3"])

    assert_equal false, @board.place(@submarine, ["A1", "B1"])
  end

  def test_that_two_ships_can_be_placed
    @board.place(@cruiser, ["A1", "B1", "C1"])
    @board.place(@submarine, ["B2", "B3"])

    assert_equal @cruiser, @board.cells["A1"].ship
    assert_equal @cruiser, @board.cells["B1"].ship
    assert_equal @cruiser, @board.cells["C1"].ship
    assert_equal @submarine, @board.cells["B2"].ship
    assert_equal @submarine, @board.cells["B3"].ship
  end
end
