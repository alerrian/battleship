require_relative '../lib/board'
require_relative '../lib/ship'

class Game
  attr_reader :cpu, :player

  

  def initialize
    @cpu = Board.new
    @player = Board.new
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
  end

  def end_game
  end

  def cpu_placement
    # logic for ship placement
    # creates and places ships on hidden board
    puts "I have placed my ships on the grid"
    puts "You now need to lay out your two ships."
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
  end
end