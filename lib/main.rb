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

# BUG - symbol error after pawn promotion in move_validator.rb:41
# FIXED? -> remove observer during pawn promotion

# BUG - pawn in b5, just captured piece. black pawn in c5 just moved from c7.
# did not trigger en passant but should have!!!

# BUG - black rook in g8, did not kill promoted white queen in f8.
# so black king was left in check! How did this capture stay through the
# move validator?

# BUG - Playing against the computer. Black king in e8 is in stalemate.
# Did not trigger game_over, therefore got an error:
# board.rb:97:in `random_black_piece': undefined method `location' for nil:NilClass (NoMethodError)
# FIXED? revised game_over, only using no_legal_moves_captures?(color)

# write tests for methods marked: NEED TO TEST
# Test Pawn Promotion for game_mode = :computer

# RANDOM COMPUTER PLAYER:
# Add a way to end the game early (resign)
# (done) Add Computer Player option during pawn promotion

# SAVE & LOAD GAME:
# Idea: Make a saved game for "new" with pieces in original spots?

# FUTURE:
# Game class is too big!
# Board class is still too big!
# Remove testing notes & add method description comments
