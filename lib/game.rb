require 'colorize'
require_relative '../lib/ship'
require_relative '../lib/cpu_player'
require_relative '../lib/player'
require_relative '../lib/print'

class Game
  include Print

  attr_reader :cpu, :player

  # :nocov:
  def initialize

  end

  def start
    menus
    end_game
  end


  def game_setup(game_type)
    @cpu = CpuPlayer.new(game_type)
    @player = Player.new(game_type)
    @player.add_cpu_target(@cpu)
    @cpu.add_player_target(@player)

    game_type == "2" ? create_custom_ships : make_default_ships

    @cpu.placement
    cpu_confirm_placement

    @player.placement
    turn_board_render
    turn(game_type)
  end

  def turn(game_type)
    print "Enter the coordinate for your shot: "
    player_shot = gets.chomp.strip.upcase
    puts ""

    cpu_shot = @cpu.board.raw_cells_keys.sample

    until ((@cpu.ships.find_all {|ship| ship.sunk? == true}).length == @cpu.ships.length) ||
          ((@player.ships.find_all {|ship| ship.sunk? == true}).length == @player.ships.length)
      print @player.shot_seq(player_shot) + print_shot_results(@cpu.board.cells[@player.shots.last]) + "\n\n"
      if game_type == "1"
        print @cpu.shot_seq(cpu_shot) + print_shot_results(@player.board.cells[@cpu.shots.last]) + "\n"
      else
        print @cpu.adv_cpu_shot_seq(cpu_shot) + print_shot_results(@player.board.cells[@cpu.shots.last]) + "\n"
      end

      turn_board_render
    end
  end

  def end_game
    if ((@player.ships.find_all {|ship| ship.sunk? == true}).length == @player.ships.length)
      print "\n*** I won! ***\n\n"
    else
      print "\n*** You won! ***\n\n"
    end

    start
  end

  def turn_board_render
    print "\n=============COMPUTER BOARD=============\n\n"

    cpu.board.render

    print "\n==============PLAYER BOARD==============\n\n"

    player.board.render(true)
  end

  def print_shot_results(target)
    if target.ship == nil
      return "shot at " + "#{target.coordinate}".colorize(:yellow) + " was a " + "MISS!".colorize(:yellow)
    elsif target.ship.sunk? == true
      return "shot at " + "#{target.coordinate}".colorize(:yellow) + " on the #{target.ship.name} was a " + "HIT and SUNK THE SHIP!".colorize(:red)
    else
      return "shot at " + "#{target.coordinate}".colorize(:yellow) + " on the #{target.ship.name} was a " + "HIT!".colorize(:red)
    end
  end

  def create_custom_ships
    p "How many ships would you like to make? (1 - 5)"
    number_of_ships = gets.chomp.to_i

    number_of_ships = 5 if number_of_ships > 5
    number_of_ships = 1 if number_of_ships <= 0

    number_of_ships.times do |num|
      ship_info = []
      until ship_info.length == 2
        p "#{num + 1} - Create your ship with name and size (ex. Name, Size : 1 - 9)?"
        ship_info = gets.chomp.strip.split(",")
      end

      ship_info[0] = ship_info[0].strip.downcase.capitalize
      ship_info[1] = ship_info[1].strip.to_i

      ship_info[1] = 9 if ship_info[1] > 9
      ship_info[1] = 1 if ship_info[1] <= 0

      @player.add_ships(Ship.new(ship_info[0], ship_info[1]))
      @cpu.add_ships(Ship.new(ship_info[0], ship_info[1]))
    end
  end

  def make_default_ships
    @p_cruiser = Ship.new("Cruiser", 3)
    @p_submarine = Ship.new("Submarine", 2)
    @player.add_ships(@p_cruiser)
    @player.add_ships(@p_submarine)

    @c_cruiser = Ship.new("Cruiser", 3)
    @c_submarine = Ship.new("Submarine", 2)
    @cpu.add_ships(@c_cruiser)
    @cpu.add_ships(@c_submarine)
  end
    # :nocov:
end
