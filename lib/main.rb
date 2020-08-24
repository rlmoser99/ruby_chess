# frozen_string_literal: true

require_relative 'chess_board.rb'
require_relative 'pieces/piece.rb'
require_relative 'pieces/pawn.rb'

board = ChessBoard.new
board.to_s

pawn = Pawn.new(:white)
board.update_value(1, 0, pawn)
