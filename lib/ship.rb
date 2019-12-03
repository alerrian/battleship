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
    if @health > 0
      @health -= 1
    else
      @sunk = true
    end
  end
end