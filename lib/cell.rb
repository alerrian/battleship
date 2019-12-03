#A cell that is initialized with a set of coordinates, without a ship
# and that it hasn't been fired upon
#Methods allow for a ship to be passed into the cell, and be fired upon
# which effects the ship class that is passed into it.


class Cell
  attr_reader :coordinate, :ship, :fired_upon, :render

  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @fired_upon = false
    @render = "."
  end

  def empty?
    return true if ship == nil
    false
  end

  def place_ship(ship)
    @ship = ship
  end

  #Only added this because the interaction pattern requests it has a method
  def fired_upon?
    @fired_upon
  end

  def fire_upon
    if ship != nil
      @ship.hit
      @ship.sunk? == false ? (@render = "H") : (@render = "X")
    else
      @render = "M"
    end
    @fired_upon = true
  end
end
