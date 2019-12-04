require_relative 'test_helper'
require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/ship'

class GameTest < Minitest::Test
  def setup
    @new_game = Game.new
  end

  def test_it_exists
    require "pry"; binding.pry
    assert_instance_of Game, @new_game
  end

end
