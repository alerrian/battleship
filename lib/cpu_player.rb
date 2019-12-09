require_relative '../lib/board'

class CpuPlayer
  attr_reader :board,
              :ai_level,
              :ships,
              :shots,
              :player,
              :possible_shots

  def initialize(game_type)
    @board = Board.new(game_type)
    @ships = []
    @shots = []
    @player = nil
    @possible_shots = []
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
        cpu_shot = @board.raw_cells_keys.sample
    end

    @player.board.cells[cpu_shot].fire_upon
    @shots.push(cpu_shot)
    "My "
  end

  def get_adv_ai_shot_coords(cpu_shot)
    all_coords = @board.cells.keys.each_cons(2).to_a
    vert_coords = @board.raw_cells_keys.each_cons(2).to_a
    vert_coords.each do |array|
      all_coords.push(array)
    end
    # require "pry"; binding.pry
    valid_predictions = all_coords.find_all do |coords|
      coords.include?(cpu_shot)
    end

    valid_predictions.flatten!.uniq!

    valid_shots = valid_predictions.find_all do |coords|
      !(@shots.include?(coords))
    end
    valid_shots
  end

  # :nocov:
  # No coverage due to random results
  def adv_cpu_shot_seq(cpu_shot)
    until @player.board.validate_coordinates?(cpu_shot) && !@shots.include?(cpu_shot)
      # AI_shot sequence. "Smart AI"
      if @player.board.cells[@shots.last].ship == nil && @possible_shots == []
        # shoot at the
        cpu_shot = @board.raw_cells_keys.sample
      else
        if @player.board.cells[@shots.last].ship == nil
          cpu_shot = @possible_shots.shuffle.pop
        elsif @player.board.cells[@shots.last].ship != nil
          if @player.board.cells[@shots.last].ship.sunk?
            @possible_shots = Array.new
            cpu_shot = @board.raw_cells_keys.sample
          else
            @possible_shots.push(get_adv_ai_shot_coords(@shots.last)).flatten!.uniq!
            cpu_shot = @possible_shots.shuffle.pop
          end
        end
      end
    end

    @player.board.cells[cpu_shot].fire_upon
    @shots.push(cpu_shot)
    "My "
  end
  # :nocov:

end
