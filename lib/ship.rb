require 'pry'

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