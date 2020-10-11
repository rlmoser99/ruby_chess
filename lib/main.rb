# frozen_string_literal: true

require 'pry'

require_relative 'board.rb'
require_relative 'displayable.rb'
require_relative 'game.rb'
require_relative 'notation_translator.rb'
require_relative 'move_validator.rb'
require_relative 'pieces/piece.rb'
require_relative 'pieces/king.rb'
require_relative 'pieces/queen.rb'
require_relative 'pieces/rook.rb'
require_relative 'pieces/bishop.rb'
require_relative 'pieces/knight.rb'
require_relative 'pieces/pawn.rb'

game = Game.new
game.play

# Maybe need to separate the piece testing current moves & current captures,
# so that testing does not need to use king in check portion of method.

# When does "checking" for check happen?
# 1. Each piece needs to remove any moves that could put their King in check.
# 2. At the beginning of a turn, if the King is in check, the move must un-check the King.

# Adding "check" to King.
# Check -> When opponent piece can attack King.
# Update legal moves -> Move can not put King in check.

# Remove each piece checking current_moves & current_captures at the beginning of each turn.

# Update visualizing valid moves & captures -> current_piece, not in Board

# Game ->
# Make a method inside #select_move_coordinates that has board check opponent pieces putting King into check.

# Should Game#select_piece_coordinates have an arry of pieces with moves/captures?

# Should Board#active_piece_moveable? remove any move that would put King in check?
# Does Board#check?(king)? Do what we need it to do? Should it do both kings in one check?

# Board.initial_placement tests are failing!!!

# current_moves = piece.moves only works in ones that inherit that from piece.
# need to change king, knight, pawn

# BUG: white pawn c4, black pawn in d5 -> triggered en passsant incorrectly!

# Remove unneccessary tests from the different pieces.

# Look into creating 2 array of pieces with moves/captures for #validate_active_piece

# refactor current_moves for Pawn, Knight, others? -> ABC complexity!!
# Pawn #current_moves & #current_captures -> Need refactored
# Knight #current_moves & #current_captures -> Need refactored

# Determine if King is in check at the beginning of the turn. Only pieces can move that can block it.
# Will need to remove captures if a King is in check at the beginning of a turn.
