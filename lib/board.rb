require './lib/cell'

# Creates the board to play the game

class Board
  attr_reader :cells

  def initialize
    # keeps cells method from overwriting the board
    # each time it is called.
    @cells = cell_generator
  end

  def cell_generator
    cell_range = ("A".."D").to_a
    hash_keys = []
    cells = {}

    4.times do |num|
      cell_range.each do |letter|
        hash_keys.push(letter + (num + 1).to_s)
      end
    end

    hash_keys.each do |key|
      cells[key] = Cell.new(key)
    end

    sorted_hash = cells.sort_by { |k, v| k }

    sorted_hash.to_h
  end

  def validate_coordinates?(coordinate)
    @cells.keys.include?(coordinate)
  end

  def valid_placement?(ship, ship_placement)
    return false if ship_placement.length != ship.ship_length

    return false if ship_placement != @cells.keys.index[(@cells.keys.index(ship_placement[0]))..(ship_placement.length)]
  end
end
