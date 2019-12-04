require './lib/cell'

# Creates the board to play the game

class Board
  attr_reader :cells, :raw_cells

  def initialize
    # keeps cells method from overwriting the board
    # each time it is called.
    @raw_cells = cell_generator
    @cells = sort_cells
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

    cells
  end

  def sort_cells
    sorted_hash = @raw_cells.sort_by { |k, v| k }

    sorted_hash.to_h
  end

  def validate_coordinates?(coordinate)
    @cells.keys.include?(coordinate)
  end

  def valid_placement?(ship, ship_placement)
    return false if ship_placement.length != ship.ship_length

    if horizontal_input?(ship_placement)
      start_point = @cells.keys.index(ship_placement[0])
      ship_placement == @cells.keys.slice((start_point), (ship_placement.length))
    else
      start_point = @raw_cells.keys.index(ship_placement[0])
      ship_placement == @raw_cells.keys.slice((start_point), (ship_placement.length))
    end
  end

  def horizontal_input?(ship_placement)
    horizontal_check = ship_placement.map do |letter|
      letter.split(//)[0]
    end
    horizontal_check.uniq!
    vertical_check = ship_placement.map do |letter|
      letter.split(//)[1]
    end
    vertical_check.uniq!
    if horizontal_check.length == 1
      true
    elsif vertical_check.length == 1
      false
    end
  end
end
