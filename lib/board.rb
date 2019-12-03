require './lib/cell'

class Board
  def initialize
    
  end

  def cells
    # { A1 => CellObj}
    #     hash = A1 => Cell(coordinate)
    range = "A".."D"

    range.to_a

    cell_hash = {}
    range.each {|key| cell_hash[key] = Cell.new(key)}
  end
end