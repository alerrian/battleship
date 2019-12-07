require_relative '../lib/ship'
require_relative '../lib/cpu_player'
require_relative '../lib/player'

class Game
  attr_reader :cpu, :player

  def initialize

  end

  def start
    menus
    turn
    end_game
  end

  def menus
    p "Welcome to BATTLESHIP"
    p "Enter P to play. Enter Q to quit."
    user_in = gets.chomp.downcase

    until user_in == "p" or user_in == "q"
      print "Please input a valid selection: "
      user_in = gets.chomp.downcase
      puts ""
    end

    if user_in == "p"
      p "What game type would you like to play? (Q to quit. Game defaults to 1)"
      p "   1. Default Battleship Board (4x4)"
      p "   2. Custom Ships on the Big Battleship Board (9x9)"
      game_type = gets.chomp
      game_type = "1" if game_type != "2"
      game_setup(game_type)
    elsif user_in.downcase == "q"
      exit
    end
  end

  def game_setup(game_type)

    @cpu = CpuPlayer.new(game_type)
    @player = Player.new(game_type)
    @player.add_cpu_target(@cpu)
    @cpu.add_player_target(@player)

    if game_type == "2"
      create_custom_ships
    else
      make_default_ships
    end

    @cpu.placement
    puts "I have placed my ships on the grid"
    print "You now need to lay out your two ships.\n\n"

    @player.placement
    turn_board_render
  end

  def turn
    print "Enter the coordinate for your shot: "
    player_shot = gets.chomp.upcase
    puts ""

    cpu_shot = @cpu.board.raw_cells_keys.sample

    until ((@cpu.ships.find_all {|ship| ship.sunk? == true}).length == @cpu.ships.length) ||
          ((@player.ships.find_all {|ship| ship.sunk? == true}).length == @player.ships.length)
      print @player.shot_seq(player_shot) + print_shot_results(@cpu.board.cells[@player.shots.last]) + "\n\n"

      print @cpu.shot_seq(cpu_shot) + print_shot_results(@player.board.cells[@cpu.shots.last]) + "\n"

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
      return"shot at #{target.coordinate} was a MISS!"
    elsif target.ship.sunk? == true
      return "shot at #{target.coordinate} on the #{target.ship.name} was a HIT and SUNK THE SHIP!"
    else
      return "shot at #{target.coordinate} on the #{target.ship.name} was a HIT!"
    end
  end

  def create_custom_ships
    p "How many ships would you like to make? (1 - 5)"
    number_of_ships = gets.chomp.to_i

    number_of_ships = 5 if number_of_ships > 5
    number_of_ships = 1 if number_of_ships <= 0

    number_of_ships.times do |num|
      p "What would you like to call this ship?"
      ship_name = gets.chomp.strip.downcase.capitalize
      p "How long would you #{ship_name} to be? (1 - 9)"
      ship_size = gets.chomp.to_i

      ship_size = 9 if ship_size > 9
      ship_size = 1 if ship_size <= 0

      @player.add_ships(Ship.new(ship_name, ship_size))
      @cpu.add_ships(Ship.new(ship_name, ship_size))
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

end
