# frozen_string_literal: true

require 'pry'

require_relative 'chess_board.rb'
require_relative 'game.rb'
require_relative 'notation_translator.rb'
require_relative 'pieces/piece.rb'
require_relative 'pieces/king.rb'
require_relative 'pieces/queen.rb'
require_relative 'pieces/rook.rb'
require_relative 'pieces/bishop.rb'
require_relative 'pieces/knight.rb'
require_relative 'pieces/pawn.rb'

game = Game.new
game.play

# def pawn_test
#   pawn = Pawn.new({ color: :white, location: [1, 0] })
#   pawn.update_moves
# end

# pawn_test
