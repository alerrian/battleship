# A ship class that initializes a ship and it's associated methods.
# Methods:
#   sunk? returns a boolean
#   hit decrements the health of the ship then checks if the ship is sunk of not
#     based on this health.
class Ship
  attr_reader :name, :ship_length, :health

  def initialize(name, ship_length)
    @name = name
    @ship_length = ship_length
    @health = ship_length
    @sunk = false
  end

  def sunk?
    @sunk
  end

  def hit
    @health -= 1

    if @health <= 0
      @sunk = true
    end
  end
end