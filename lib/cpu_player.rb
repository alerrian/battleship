require_relative '../lib/board'

class CpuPlayer
  attr_reader :board,
              :ai_level,
              :ships,
              :shots,
              :player

  def initialize(game_type)
    @board = Board.new(game_type)
    @ships = []
    @shots = []
    @player = nil
  end

  def add_player_target(player)
    @player = player
  end

  def add_ships(ship)
    @ships.push(ship)
  end

  def placement
    @ships.each do |ship|
      coords = get_valid_positions(ship)
      @board.place(ship, coords)
    end

    # @board.render
  end

  def get_valid_positions(ship)
    all_coords = @board.cells.keys.each_cons(ship.ship_length).to_a
    vert_coords = @board.raw_cells_keys.each_cons(ship.ship_length).to_a
    vert_coords.each do |array|
      all_coords.push(array)
    end
    valid_coords = all_coords.find_all do |coord_section|
      @board.valid_placement?(ship, coord_section)
    end

    position_index = rand(0..(valid_coords.length - 1))
    valid_coords[position_index]
  end

  def shot_seq(cpu_shot)
    until @player.board.validate_coordinates?(cpu_shot) && !@shots.include?(cpu_shot)
      # AI_shot sequence. "Smart AI"
      if @player.board.cells[@shots.last].ship == nil || @player.board.cells[@shots.last].ship.sunk?
        # shoot at the
        cpu_shot = @board.raw_cells_keys.sample
      else
        # require 'pry'; binding.pry
        if @shots.include?(@board.raw_cells_keys[@board.raw_cells_keys.index(@shots.last) + 1])
          cpu_shot = @board.raw_cells_keys.sample
        else
          cpu_shot = @board.raw_cells_keys[@board.raw_cells_keys.index(@shots.last) + 1]
        end
      end
    end

    @player.board.cells[cpu_shot].fire_upon
    @shots.push(cpu_shot)
    "My "
  end

end
