# frozen_string_literal: true

require_relative 'board.rb'
require_relative 'displayable.rb'
require_relative 'game.rb'
require_relative 'game_prompts.rb'
require_relative 'notation_translator.rb'
require_relative 'move_validator.rb'
require_relative 'serializer.rb'
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

extend GamePrompts
extend Serializer

puts game_mode_choices
input = select_game_mode

if input == '1'
  single_player = Game.new(1)
  single_player.setup_board
  single_player.play
elsif input == '2'
  two_player = Game.new(2)
  two_player.setup_board
  two_player.play
elsif input == '3'
  load_game.play
end

# SAVE & LOAD GAME:
# (done) Make the game save & EXIT only at start of turn
# (done) It errors when there is not a saved game!
# (done) Write Tests
# Send link to Mark to review code.

# REFACTOR:
# Game class is too big - ok?
# Board class is still too big - ok?
# -> move initial placement into module or serialize it?
# Remove the reek ideas.md file
# Go through game and try to 'break' user input with invalid info
