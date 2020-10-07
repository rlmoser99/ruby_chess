# frozen_string_literal: true

require 'pry'

require_relative 'board.rb'
require_relative 'displayable.rb'
require_relative 'game.rb'
require_relative 'notation_translator.rb'
require_relative 'pieces/piece.rb'
require_relative 'pieces/king.rb'
require_relative 'pieces/queen.rb'
require_relative 'pieces/rook.rb'
require_relative 'pieces/bishop.rb'
require_relative 'pieces/knight.rb'
require_relative 'pieces/pawn.rb'

game = Game.new
game.play

# Adding "check" to King.
# Check -> When opponent piece can attack King.
# Update legal moves -> Move can not put King in check.

# Remove each piece checking current_moves & current_captures at the beginning of each turn.

# Visualizing valid moves & captures
# If a move would put King in check, it needs to be removed!!!

# Game ->
# Make a method inside #select_move_coordinates that has board check opponent pieces putting King into check.

# Should Game#select_piece_coordinates have an arry of pieces with moves/captures?

# Should Board#active_piece_moveable? remove any move that would put King in check?
# Does Board#check?(king)? Do what we need it to do? Should it do both kings in one check?

# BUG: white pawn c4, black pawn in d5 -> triggered en passsant incorrectly!
