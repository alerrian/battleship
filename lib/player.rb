require_relative '../lib/board'
require_relative '../lib/print'

class Player
  include Print

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
      player_ship_print(ship.name, ship.ship_length)
      # print "The #{ship.name} is #{ship.ship_length} units long.\n"
      # print "Please enter the coordinates placement.\n"
      user_coords = gets.chomp.upcase.split
      
      while @board.place(ship, user_coords) == false
        player_invalid_coords_prompt(ship.name, user_coords)
        # print "Please enter valid coordinates(a1 b1 c1): "
        user_coords = gets.chomp.upcase.split
        puts ""
      end

      player_placement_confirm(ship.name, user_coords)

    end
  end

  def shot_seq(player_shot)
    until @cpu.board.validate_coordinates?(player_shot) && !(@shots.include?(player_shot))
      player_invalid_shot_coord
      # print "Please enter a valid coordinate: "
      player_shot = gets.chomp.upcase
      puts ""
    end

    @cpu.board.cells[player_shot].fire_upon
    @shots.push(player_shot)
    "Your "
  end

end
