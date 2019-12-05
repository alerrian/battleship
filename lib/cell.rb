class Cell
  attr_reader :coordinate, :ship, :fired_upon, :symbol

  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @fired_upon = false
    @symbol = "."
  end

  def empty?
    return true if ship == nil
    false
  end

  def place_ship(ship)
    @ship = ship
  end

  def fired_upon?
    @fired_upon
  end

  def fire_upon
    if ship != nil
      @ship.hit
      @ship.sunk? == false ? (@symbol = "H") : (@symbol = "X")
    else
      @symbol = "M"
    end
    @fired_upon = true
  end

  def render(player = false)
    if player == true && @ship != nil && @fired_upon == false
      return @symbol = "S"
    elsif @ship != nil && @ship.sunk? == true
      return @symbol = "X"
    end
    return @symbol
  end

end
