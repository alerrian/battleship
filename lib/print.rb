# A module that can be used in other classes as a way to clean up some other methods.
module Print

  def player_ship_print(ship, ship_length)
    print "The #{ship} is #{ship_length} units long.\n\n"
    puts "Please enter the coordinates placement (ex. A1 A2 A3): "
  end

  def player_invalid_coords_prompt(ship, user_coords)
    print "Your placement for #{ship} at #{user_coords} was invalid.\n"
    print "Please enter new valid coordinates (ex. A1 A2 A3): "
  end

  def player_placement_confirm(ship, user_coords)
    print "You placed your #{ship} at #{user_coords}.\n\n"
  end

  def player_invalid_shot_coord
    print "Please enter a valid coordinate: "
  end
end