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
end