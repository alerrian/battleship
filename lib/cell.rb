require 'colorize'

class Cell
  attr_reader :coordinate, :ship, :fired_upon, :symbol

  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @fired_upon = false
    @symbol = ".".colorize(:blue)
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
      @ship.sunk? == false ? (@symbol = "H".colorize(:red)) : (@symbol = "X".colorize(:red))
    else
      @symbol = "M"
    end
    @fired_upon = true
  end

  def render(player = false)
    if player == true && @ship != nil && @fired_upon == false
      return @symbol = "S".colorize(:green)
    elsif @ship != nil && @ship.sunk? == true
      return @symbol = "X".colorize(:red)
    end
    return @symbol
  end

end
