require_relative 'test_helper'
require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/ship'

class GameTest < Minitest::Test
  def setup
    @new_game = Game.new
  end

  def test_it_exists
    assert_instance_of Game, @new_game
  end

  def test_cpu_has_valid_placements
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)

    placement_for_crusier = @new_game.get_valid_positions(cruiser)
    placement_for_submarine = @new_game.get_valid_positions(submarine)

    assert_equal true, @new_game.cpu.valid_placement?(cruiser, placement_for_crusier)
    assert_equal true, @new_game.cpu.valid_placement?(submarine, placement_for_submarine)
  end

  def test_cpu_can_place_its_ships_without_error
    assert_nil  @new_game.cpu_placement
  end

end
