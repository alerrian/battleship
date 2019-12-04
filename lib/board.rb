require './lib/cell'

# Creates the board to play the game

class Board
  attr_reader :cells, :raw_cells_keys

  def initialize
    @raw_cells_keys = []
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

    @raw_cells_keys = cells.keys

    sorted_hash = cells.sort_by { |k, v| k }

    sorted_hash.to_h
  end

  def validate_coordinates?(coordinate)
    @cells.keys.include?(coordinate)
  end

  def valid_placement?(ship, ship_placement)
    #Guard clause for placement size for the ship placement
    return false if ship_placement.length != ship.ship_length

    #If the method returns true use the sorted cells A1, A2, A3 etc
    if horizontal_input?(ship_placement)
      #SP is the index position in the keys array for the first inputed position
      start_point = @cells.keys.index(ship_placement[0])
      #Slice pulls an array out from the SP to a certain distance
      ship_placement == @cells.keys.slice((start_point), (ship_placement.length))
    #When false the raw_cells is used which is order based on number A1, B1, C1 etc
    elsif horizontal_input?(ship_placement) == false
      start_point = @raw_cells_keys.index(ship_placement[0])
      ship_placement == @raw_cells_keys.slice((start_point), (ship_placement.length))
    else
      false
    end
  end

#This method is used to check if the input is for horizontal or
#vertical placement
  def horizontal_input?(ship_placement)
    #Pull out the Letters of the coordinate only
    horizontal_check = ship_placement.map do |letter|
      letter.split(//)[0]
    end
    #remove all duplicates - A correct placement should be with only one row (A, B, C, etc)
    horizontal_check.uniq!
    #Pull out the number of the coordinate only
    vertical_check = ship_placement.map do |letter|
      letter.split(//)[1]
    end
    #remove all duplicates - Correct vert placement should be in one column (1, 2, 3, etc)
    vertical_check.uniq!
    if horizontal_check.length == 1
      true
    elsif vertical_check.length == 1
      false
    end
  end
end
