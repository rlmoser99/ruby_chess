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

# SAVE & LOAD GAME:
# 1. Make a saved game for "new" with pieces in original spots. ??

# FUTURE NOTES:
# Board class is too big. Is there an abstraction or way that can reduce it?
# Tests for move_validator may not be testing accurately, due to stubbing?
# -> Test method that is stubbed, because it's easier to test that one.
# Create 2 arrays of black & white pieces?
