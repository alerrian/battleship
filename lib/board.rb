require './lib/cell'

# Creates the board to play the game

class Board
  attr_reader :cells

  def initialize
    # keeps cells method from overwriting the board
    # each time it is called.
    @cells = cell_generator
    @v_valid = false
    @h_valid = false
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
    return false if ship.ship_length != ship_placement.length

    if check_vertical(ship_placement) != 1
      if check_horizontal(ship_placement) == 1
        check_consecutive(ship, ship_placement) ? true : false
      else
        false
      end
    else
      true
    end
  end

  def check_horizontal(ship_placement)
    horizontal_check = ship_placement.map do |value|
      value.split(//)[0]
    end

    horizontal_check.uniq.length
  end

  def check_vertical(ship_placement)
    vertical_check = ship_placement.map do |value|
      value.split(//)[1]
    end

    vertical_check.uniq.length
  end

  def check_consecutive(ship, ship_placement)
    start_point = @cells.keys.index(ship_placement[0])
    if ship_placement.length == ship.ship_length and
                                ship_placement ==
                                @cells.keys.slice((start_point), (ship_placement.length))
      true
    else
      false
    end
  end
end
