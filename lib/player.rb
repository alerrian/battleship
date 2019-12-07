require_relative '../lib/board'

class Player
  attr_reader :board,
              :ships,
              :shots,
              :cpu

  def initialize(game_type)
    @board = Board.new(game_type)
    @ships = []
    @shots = []
    @cpu = nil
  end

  def add_cpu_target(cpu)
    @cpu = cpu
  end

  def add_ships(ship)
    @ships.push(ship)
  end

  def placement
    @ships.each do |ship|
      @board.render(true)
      print "The #{ship.name} is #{ship.ship_length} units long.\n"
      print "Please enter the coordinates placement.\n"
      user_coords = gets.chomp.upcase.split
      while @board.place(ship, user_coords) == false
        print "Please enter valid coordinates(a1 b1 c1): "
        user_coords = gets.chomp.upcase.split
        puts ""
      end

    end
  end

  def shot_seq(player_shot)
    until @cpu.board.validate_coordinates?(player_shot) && !(@shots.include?(player_shot))
      print "Please enter a valid coordinate: "
      player_shot = gets.chomp.upcase
      puts ""
    end

    @cpu.board.cells[player_shot].fire_upon
    @shots.push(player_shot)
    "Your "
  end

end
