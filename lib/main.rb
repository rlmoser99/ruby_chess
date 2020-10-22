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
require_relative 'movement/basic_movement.rb'
require_relative 'movement/en_passant_movement.rb'
require_relative 'movement/pawn_promotion_movement.rb'
require_relative 'movement/castling_movement.rb'

game = Game.new
game.play

# BUG - en passant. white pawn in h5, previous piece black pawn in f5
# triggered en passant. Make a test, then fix it!

# RANDOM COMPUTER PLAYER:
# Add a way to end the game early (resign)

# SAVE & LOAD GAME:
# Idea: Make a saved game for "new" with pieces in original spots?

# FUTURE:
# Board class is still too big!
# Remove testing notes & add method description comments
