# frozen_string_literal: true

require_relative 'board.rb'
require_relative 'displayable.rb'
require_relative 'game.rb'
require_relative 'game_prompts.rb'
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

# SAVE & LOAD GAME:
# Idea: Make a saved game for "new" with pieces in original spots?
# Make the game save & EXIT only at start of turn

# REFACTOR:
# Game class is too big - ok?
# Board class is still too big - ok?
# -> move initial placement into module or serialize it?
# Remove the reek ideas.md file

# Created a test situation w/ 5 pieces that should have valid moves.
# def initial_placement
#   @data[0][0] = King.new(self, { color: :black, location: [0, 0] })
#   @data[3][6] = Queen.new(self, { color: :black, location: [3, 6] })
#   @data[2][7] = Queen.new(self, { color: :white, location: [2, 7] })
#   @data[7][6] = King.new(self, { color: :white, location: [7, 6] })
#   @data[4][5] = Rook.new(self, { color: :white, location: [4, 5] })
#   @data[5][7] = Bishop.new(self, { color: :white, location: [5, 7] })
#   @data[3][4] = Knight.new(self, { color: :white, location: [3, 4] })
#   @data[3][4] = Knight.new(self, { color: :white, location: [3, 4] })
#   @data[6][4] = Pawn.new(self, { color: :white, location: [6, 4] })
#   @white_king = @data[7][6]
#   @black_king = @data[0][0]
#   update_all_moves_captures
# end
