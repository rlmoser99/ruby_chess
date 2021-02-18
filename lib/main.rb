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
require_relative 'movement/movement_factory.rb'
require_relative 'movement/basic_movement.rb'
require_relative 'movement/en_passant_movement.rb'
require_relative 'movement/pawn_promotion_movement.rb'
require_relative 'movement/castling_movement.rb'

extend GamePrompts
extend Serializer

def play_game(input)
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
end

loop do
  puts game_mode_choices
  mode = select_game_mode
  play_game(mode)
  break if repeat_game == :quit
end
