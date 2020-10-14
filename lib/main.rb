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

# GENERAL REFACTOR:
# 1. Review all methods to see if they should be Public or Private
# 2. Make sure public ones are tested
# 3. Review all tests & remove unneccessary/repetitive tests.
# 4. Run reek for code feedback
# 5. Tests for move_validator may not be testing well, due to stubbing?
# 6. Double-check rubocop warnings.

# PLAYER TURNS
# 1. Warn player when their King is in check (start of turn)
# -> Does there need to be Board#check? If not, remove Board#check? tests
# 2. Create 2 arrays of black & white pieces Game#select_piece_coordinates
# 3. Need to add 'Game Over' checks

# CASTLING:

# PROMOTION:

# SAVE & LOAD GAME:
# 1. Make a saved game for "new" with pieces in original spots. ??
