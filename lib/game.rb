require_relative '../lib/board'
require_relative '../lib/ship'

class Game
  def initialize
    @cpu = Board.new
    @player = Board.new
  end

  def start
  end

  def turn
  end

  def end_game
  end
end