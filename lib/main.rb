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

# CASTLING:
# 1. #valid_castling?
# (done) The king can not be in check.
# (done) All squares between king & rook must be empty.
# (done) The king & rook can not have moved yet
# (done) The king can not move through a square currently under attack.
# After moving the king can not be in check -> handled in Move_Validator

# The king can move 2 squares towards rook (either way)

# Black king-side
# King [0, 4] -> [0, 6] & Rook [0, 7] -> [0, 5]
# Black queen-side
# King [0, 4] -> [0, 2] & Rook [0, 0] -> [0, 3]

# White king-side
# King [7, 4] -> [7, 6] & Rook [7, 7] -> [7, 5]
# White queen-side
# King [7, 4] -> [7, 2] & Rook [7, 0] -> [7, 3]

# Add Game#castling_warning -> inside #select_move_coordinates
# Add Board#possible_castling? -> triggers Game#castling_warning

# SAVE & LOAD GAME:
# 1. Make a saved game for "new" with pieces in original spots. ??

# RANDOM COMPUTER PLAYER:

# FUTURE NOTES:
# Board class is too big. Is there an abstraction or way that can reduce it?
# Tests for move_validator may not be testing accurately, due to stubbing?
# -> Test method that is stubbed, because it's easier to test that one.
# Create 2 arrays of black & white pieces?
# En_Passant deletes observer in two locations. Verify if both are needed.
# Add a way to end the game early (resign)
# King#find_possible_moves(board) rubocop warning
