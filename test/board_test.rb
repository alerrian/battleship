require_relative 'test_helper'
require_relative '../lib/board'

class BoardTest < Minitest::Test
  def setup
    @board = Board.new
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
end