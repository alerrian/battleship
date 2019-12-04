require_relative '../lib/board'
require_relative '../lib/ship'

class Game
  attr_reader :cpu, :player

  def initialize
    @cpu = Board.new
    @player = Board.new
    @cpu_shots = []
    @player_shots = []
  end

  def start
    # cpu places ships on board
    cpu_placement

    # player places ships on board
    player_placement

    # begins the turn
    turn
  end

  def turn
    turn_board_render

  end

  def end_game
  end

  def cpu_placement
    cpu_ships = []
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)
    cpu_ships.push(cruiser)
    cpu_ships.push(submarine)

    cpu_ships.each do |ship|
      coords = get_valid_positions(ship)
      @cpu.place(ship, coords)
    end

    @cpu.render(true)
    # logic for ship placement
    #   gen random array
    #     until place == true
    #       gen random array
    # creates and places ships on hidden board
    puts "I have placed my ships on the grid"
    print "You now need to lay out your two ships.\n\n"
  end

  def player_placement
    print "The Cruiser is three units long and the Submarine is two units long.\n\n"

    # Print empty board
    player.render

    print "\nEnter the squares for the CRUISER: "
    cruiser = Ship.new(cruiser, 3)
    user_coords = gets.chomp.upcase.split
    puts ""

    # take in coordinates and place them on game board.
    # refresh board for each ship
    while player.place(cruiser, user_coords) == false
      print "Please enter valid coordinates(a1 b1 c1): "
      user_coords = gets.chomp.upcase.split
      puts ""
    end

    player.render(true)

    print "\nEnter the squares for the SUBMARINE: "
    submarine = Ship.new(submarine, 2)
    user_coords = gets.chomp.upcase.split
    puts ""

    # take in coordinates and place them on game board.
    # refresh board for each ship
    while player.place(submarine, user_coords) == false
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

    position_index = rand(0..(valid_coords.length))

    valid_coords[position_index]
  end

  def turn_board_render
    print "\n=============COMPUTER BOARD=============\n\n"

    cpu.render(true)

    print "\n==============PLAYER BOARD==============\n\n"

    player.render(true)
  end
end
