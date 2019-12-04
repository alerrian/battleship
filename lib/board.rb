require './lib/cell'

# Creates the board to play the game

class Board
  attr_reader :cells, :raw_cells

  def initialize
    # keeps cells method from overwriting the board
    # each time it is called.
    @cells = cell_generator
    @raw_cells = {}
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

    @raw_cells = cells

    sorted_hash = cells.sort_by { |k, v| k }

    sorted_hash.to_h
  end

  def validate_coordinates?(coordinate)
    @cells.keys.include?(coordinate)
  end

  def valid_placement?(ship, ship_placement)
    
  end

  # def valid_placement?(ship, ship_placement)
  #   require "pry"; binding.pry
  #   range = Math.sqrt(@cells.keys.length)
  #   start_point = @cells.keys.index(ship_placement[0])
  #   if hor_and_vert_check(ship_placement)
  #     if ship_placement.length == ship.ship_length
  #       if ship_placement == @cells.keys.slice((start_point), (ship_placement.length)) or
  #         (ship_placement == @cells.keys.step((start_point), range))
  #         true
  #       else
  #         false
  #       end
  #     else
  #       false
  #     end
  #   else
  #     false
  #   end
  # end

  def hor_and_vert_check(ship_placement)
    horizontal_check = ship_placement.map do |letter|
      letter.split(//)[0]
    end
    horizontal_check.uniq!
    vertical_check = ship_placement.map do |letter|
      letter.split(//)[1]
    end
    vertical_check.uniq!
    if horizontal_check.length == 1 or vertical_check.length == 1
      true
    else
      false
    end
  end
end
