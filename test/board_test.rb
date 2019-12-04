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
    cruiser_placement2 = ["A2", "A3", "A4"]

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

end
