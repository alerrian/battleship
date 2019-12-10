# A module that can be used in other classes as a way to clean up some other methods.
# :nocov:
#No coverage because console printout
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

  def menus
    print "Welcome to BATTLESHIP\n".colorize(:yellow)
    print "Enter " + "P".colorize(:yellow) + " to play. Enter " + "Q".colorize(:yellow)+ " to quit.\n"
    user_in = gets.chomp.downcase

    until user_in == "p" or user_in == "q"
      print "Please input a valid selection: "
      user_in = gets.chomp.strip.downcase
      puts ""
    end

    if user_in == "p"
      p "What game type would you like to play? (Game defaults to 1)"
      print "   1. ".colorize(:yellow) +"Default Battleship Board (4x4)\n"
      print "   2. ".colorize(:yellow) + "Custom Ships on the Big Battleship Board (9x9)\n"
      game_type = gets.chomp.strip
      game_type = "1" if game_type != "2"
      game_setup(game_type)
    elsif user_in.downcase == "q"
      exit
    end
  end

  def cpu_confirm_placement
    puts "I have placed my ships on the grid"
    print "You now need to lay out your two ships.\n\n"
  end
end

# :nocov:
