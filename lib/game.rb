require_relative '../lib/board'
require_relative '../lib/ship'

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
    @cpu_shots = []
    @player_shots = []
    @cpu_ships = []
    @player_ships = []
    @cpu = Board.new(game_type)
    @player = Board.new(game_type)

    if game_type == "2"
      create_custom_ships
    else
      make_default_ships
    end

    cpu_placement
    player_placement
    turn_board_render
  end

  def turn
    print "Enter the coordinate for your shot: "
    player_shot = gets.chomp.upcase
    puts ""

    cpu_shot = @cpu.raw_cells_keys.sample

    until ((@cpu_ships.find_all {|ship| ship.sunk? == true}).length == @cpu_ships.length) ||
          ((@player_ships.find_all {|ship| ship.sunk? == true}).length == @player_ships.length)
      player_shot_seq(player_shot)

      cpu_shot_seq(cpu_shot)

      turn_board_render
    end
  end

  def end_game
    if ((@player_ships.find_all {|ship| ship.sunk? == true}).length == @player_ships.length)
      print "\n*** I won! ***\n\n"
    else
      print "\n*** You won! ***\n\n"
    end

    start
  end

  def cpu_placement
    @cpu_ships.each do |ship|
      coords = get_valid_positions(ship)
      @cpu.place(ship, coords)
    end

    @cpu.render(true)

    puts "I have placed my ships on the grid"
    print "You now need to lay out your two ships.\n\n"
  end

  def player_placement
    @player_ships.each do |ship|
      player.render(true)
      print "The #{ship.name} is #{ship.ship_length} units long.\n"
      print "Please enter the coordinates placement.\n"
      user_coords = gets.chomp.upcase.split
      while player.place(ship, user_coords) == false
        print "Please enter valid coordinates(a1 b1 c1): "
        user_coords = gets.chomp.upcase.split
        puts ""
      end
      player.render(true)
    end
  end

  def get_valid_positions(ship)
    all_coords = @cpu.cells.keys.each_cons(ship.ship_length).to_a
    vert_coords = @cpu.raw_cells_keys.each_cons(ship.ship_length).to_a
    vert_coords.each do |array|
      all_coords.push(array)
    end
    valid_coords = all_coords.find_all do |coord_section|
      @cpu.valid_placement?(ship, coord_section)
    end

    position_index = rand(0..(valid_coords.length - 1))
    valid_coords[position_index]
  end

  def turn_board_render
    print "\n=============COMPUTER BOARD=============\n\n"

    cpu.render(true)

    print "\n==============PLAYER BOARD==============\n\n"

    player.render(true)
  end

  def player_shot_seq(player_shot)
    until cpu.validate_coordinates?(player_shot) && !(@player_shots.include?(player_shot))
      print "Please enter a valid coordinate: "
      player_shot = gets.chomp.upcase
      puts ""
    end

    cpu.cells[player_shot].fire_upon
    @player_shots.push(player_shot)
    print "Your " + print_shot_results(@cpu.cells[player_shot]) + "\n\n"
  end

  def cpu_shot_seq(cpu_shot)
    until player.validate_coordinates?(cpu_shot) && !@cpu_shots.include?(cpu_shot)
      # AI_shot sequence. "Smart AI"
      if @player.cells[@cpu_shots.last].ship == nil || @player.cells[@cpu_shots.last].ship.sunk?
        # shoot at the
        cpu_shot = @cpu.raw_cells_keys.sample
      else
        # require 'pry'; binding.pry
        if @cpu_shots.include?(@cpu.raw_cells_keys[@cpu.raw_cells_keys.index(@cpu_shots.last) + 1])
          cpu_shot = @cpu.raw_cells_keys.sample
        else
          cpu_shot = @cpu.raw_cells_keys[@cpu.raw_cells_keys.index(@cpu_shots.last) + 1]
        end
      end
    end

    @player.cells[cpu_shot].fire_upon
    @cpu_shots.push(cpu_shot)
    print "My " + print_shot_results(@player.cells[cpu_shot]) + "\n"
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
    if number_of_ships > 5
      number_of_ships = 5
    elsif number_of_ships <= 0
      number_of_ships = 1
    end


    number_of_ships.times do |num|
      p "What would you like to call this ship?"
      ship_name = gets.chomp.strip.downcase.capitalize
      p "How long would you #{ship_name} to be? (1 - 9)"
      ship_size = gets.chomp.to_i
      if ship_size > 9
        ship_size = 9
      elsif ship_size <= 0
        ship_size = 1
      end
      @player_ships.push(Ship.new(ship_name, ship_size))
      @cpu_ships.push(Ship.new(ship_name, ship_size))
    end
  end

  def make_default_ships
    @p_cruiser = Ship.new("Cruiser", 3)
    @p_submarine = Ship.new("Submarine", 2)
    @player_ships.push(@p_cruiser)
    @player_ships.push(@p_submarine)

    @c_cruiser = Ship.new("Cruiser", 3)
    @c_submarine = Ship.new("Submarine", 2)
    @cpu_ships.push(@c_cruiser)
    @cpu_ships.push(@c_submarine)
  end


end
