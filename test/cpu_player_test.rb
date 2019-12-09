require_relative 'test_helper'
require_relative '../lib/cpu_player'
require_relative '../lib/player'
require_relative '../lib/ship'

class CpuPlayerTest < MiniTest::Test
  def setup
    @cpu = CpuPlayer.new("1")
    @player = Player.new("1")
    @c_cruiser = Ship.new("Cruiser", 3)
    @c_submarine = Ship.new("Submarine", 2)

    @p_cruiser = Ship.new("Cruiser", 3)
    @p_submarine = Ship.new("Submarine", 2)
    @player.add_ships(@p_cruiser)
    @player.add_ships(@p_submarine)
  end

  def test_it_exists
    assert_instance_of CpuPlayer, @cpu
  end

  def test_it_has_starting_attributes
    assert_instance_of Board, @cpu.board
    assert_equal [], @cpu.ships
    assert_equal [], @cpu.shots
    assert_nil @cpu.player
  end

  def test_it_can_take_a_player_as_opponent
    @cpu.add_player_target(@player)

    assert_instance_of Player, @cpu.player
  end

  def test_it_can_add_ships
    @cpu.add_ships(@c_cruiser)
    @cpu.add_ships(@c_submarine)

    assert_equal [@c_cruiser, @c_submarine], @cpu.ships
  end

  def test_it_can_pull_valid_ship_placements
    placement_for_crusier = @cpu.get_valid_positions(@c_cruiser)
    placement_for_submarine = @cpu.get_valid_positions(@c_submarine)

    assert_equal true, @cpu.board.valid_placement?(@c_cruiser, placement_for_crusier)
    assert_equal true, @cpu.board.valid_placement?(@c_submarine, placement_for_submarine)
  end

  def test_it_can_place_an_array_of_ships
    @cpu.add_ships(@c_cruiser)
    @cpu.add_ships(@c_submarine)

    @cpu.placement

    #pull array to test against#
    cell_ship_values = @cpu.board.cells.values.map do |cell|
      cell.ship
    end


    assert_includes cell_ship_values, @c_cruiser
    assert_includes cell_ship_values, @c_submarine
  end

  def test_cpu_can_shot_randomly_at_target
    @cpu.add_player_target(@player)
    cpu_shot = @cpu.board.raw_cells_keys.sample
    @cpu.shot_seq(cpu_shot)

    assert_includes @cpu.shots, cpu_shot
    assert_equal true, @player.board.cells[cpu_shot].fired_upon
  end

  def test_it_can_make_smart_target_decisions_based_on_last_shot
    @cpu.add_player_target(@player)
    @player.board.place(@p_submarine, ["B1", "B2", "B3"])
    cpu_shot = "B2"

    assert_equal ["B1", "B2", "B3", "A2", "C2"], @cpu.get_adv_ai_shot_coords(cpu_shot)
  end


end
