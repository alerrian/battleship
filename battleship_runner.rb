require_relative './lib/game'

p "Welcome to BATTLESHIP"
p "Enter p to play. Enter q to quit."

user_in = gets.chomp.downcase

until user_in == "p" or user_in == "q"
  p "Please input a valid selection"
  user_in = gets.chomp.downcase
end

if user_in == "p"
  p "Would you like to play (D)efault or (T)rue Battleship"
  user_in = gets.chomp.upcase
  new_game = Game.new(user_in)

  new_game.start
elsif user_in == "q"
  # quit game
  exit
end
