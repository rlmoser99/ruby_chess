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

# KING-CHECK BRANCH
# (done) Each piece removes any moves that could put their King in check.
# (done) Each piece removes any captures that could put their King in check.
# (did) Beginning turns, if King is in check, the move must un-check the King.

# PLAYER TURNS
# 1. Warn player when their King is in check (start of turn)
# -> Does there need to be Board#check? If not, remove Board#check? tests
# 2. Create 2 arrays of black & white pieces Game#select_piece_coordinates
# 3. Need to add 'Game Over' checks

# PIECE REFACTOR:
# 1. Refactor Pawn #current_moves & #current_captures
# 2. Refactor Knight #current_moves & #current_captures
# 3. Does King need to be refactored?
# 4. Re-name methods for how they currently function.
# 5. Look closer at Piece Inheritance and instance variables?
# BUG: white pawn c4, black pawn in d5 -> triggered en passsant incorrectly!

# GENERAL REFACTOR:
# 1. Review all methods to see if they should be Public or Private
# 2. Make sure public ones are tested
# 3. Review all tests & remove unneccessary/repetitive tests.
# 4. Run reek for code feedback

# CASTLING:

# PROMOTION:

# SAVE & LOAD GAME:
# 1. Make a saved game for "new" with pieces in original spots. ??
