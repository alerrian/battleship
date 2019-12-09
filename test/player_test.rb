require_relative 'test_helper'
require_relative '../lib/cpu_player'
require_relative '../lib/player'
require_relative '../lib/ship'

class PlayerTest < MiniTest::Test
  def setup
    @cpu = CpuPlayer.new("1")
    @player = Player.new("1")
    @c_cruiser = Ship.new("Cruiser", 3)
    @c_submarine = Ship.new("Submarine", 2)

    @p_cruiser = Ship.new("Cruiser", 3)
    @p_submarine = Ship.new("Submarine", 2)
  end

  def test_it_exists
    assert_instance_of Player, @player
  end

  def test_it_has_starting_attributes
    assert_instance_of Board, @player.board
    assert_equal [], @player.ships
    assert_equal [], @player.shots
    assert_nil @player.cpu
  end

  def test_it_can_take_a_cpu_as_oppent
    @player.add_cpu_target(@cpu)

    assert_instance_of CpuPlayer, @player.cpu
  end

  def test_it_can_add_ships
    @player.add_ships(@p_cruiser)
    @player.add_ships(@p_submarine)

    assert_equal [@p_cruiser, @p_submarine], @player.ships
  end

end
