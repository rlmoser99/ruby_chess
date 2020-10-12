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

# When does "checking" for check happen?
# (done) Each piece needs to remove any moves that could put their King in check.
# 2. At the beginning of a turn, if the King is in check, the move must un-check the King.

# BUG: Just like when a piece's moves can put King in check.
# That piece's current captures need to check that that capture won't put king in check!

# Adding "check" instance variable to King?

# Remove each piece checking current_moves & current_captures at the beginning of each turn.

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

# PIECE REFACTOR:
# Re-name methods for how they currently function.
# Refactor Pawn #current_moves & #current_captures
# Refactor Knight #current_moves & #current_captures

# Determine if King is in check at the beginning of the turn. Only pieces can move that can block it.
# Will need to remove captures if a King is in check at the beginning of a turn.

# Organize & Test code
# 1. Public vs. Private
# 2. Make sure public ones are tested
# 3. Piece Inheritance and instance variables?
