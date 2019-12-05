require_relative '../lib/board'
require_relative '../lib/ship'

class Game
  attr_reader :cpu, :player

  def initialize
    @cpu_shots = []
    @player_shots = []
    @c_cruiser = Ship.new("Cruiser", 3)
    @c_submarine = Ship.new("Submarine", 2)
  end

  def start
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
      p "   1. Default Battleship (4x4)"
      p "   2. Big Board Battleship (9x9)"
      game_type = gets.chomp.upcase
      @cpu = Board.new(game_type)
      @player = Board.new(game_type)

    elsif user_in.downcase == "q"
      exit
    end
    
    cpu_placement

    player_placement

    turn_board_render

    turn
  end

  def turn
    print "Enter the coordinate for your shot: "
    player_shot = gets.chomp.upcase
    puts ""

    cpu_shot = @cpu.raw_cells_keys.sample

    until (@p_cruiser.sunk? && @p_submarine.sunk?) || (@c_cruiser.sunk? && @c_submarine.sunk?)
      player_shot_seq(player_shot)

      cpu_shot_seq(cpu_shot)

      turn_board_render
    end

    end_game
  end

  def end_game
    if @p_cruiser.sunk? && @p_submarine.sunk?
      print "\n*** I won! ***\n\n"
    else
      print "\n*** You won! ***\n\n"
    end

    start
  end

  def cpu_placement
    cpu_ships = []
    cpu_ships.push(@c_cruiser)
    cpu_ships.push(@c_submarine)

    cpu_ships.each do |ship|
      coords = get_valid_positions(ship)
      @cpu.place(ship, coords)
    end

    @cpu.render(true)

    puts "I have placed my ships on the grid"
    print "You now need to lay out your two ships.\n\n"
  end

  def player_placement
    print "The Cruiser is three units long and the Submarine is two units long.\n\n"

    player.render(true)

    print "\nEnter the squares for the CRUISER: "
    @p_cruiser = Ship.new("Cruiser", 3)
    user_coords = gets.chomp.upcase.split
    puts ""

    while player.place(@p_cruiser, user_coords) == false
      print "Please enter valid coordinates(a1 b1 c1): "
      user_coords = gets.chomp.upcase.split
      puts ""
    end

    player.render(true)

    print "\nEnter the squares for the SUBMARINE: "
    @p_submarine = Ship.new("Submarine", 2)
    user_coords = gets.chomp.upcase.split
    puts ""

    while player.place(@p_submarine, user_coords) == false
      print "Please enter valid coordinates(a1 b1 c1): "
      user_coords = gets.chomp.upcase.split
      puts ""
    end

    player.render(true)
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
      if @player.cells[@cpu_shots.last].ship == nil || @player.cells[@cpu_shots.last].ship.sunk? || @cpu.raw_cells_keys[@cpu.raw_cells_keys.index(@cpu_shots.last) + 1] == nil
        # shoot at the 
        cpu_shot = @cpu.raw_cells_keys.sample
      else
        cpu_shot = @cpu.raw_cells_keys[@cpu.raw_cells_keys.index(@cpu_shots.last) + 1]
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

end
