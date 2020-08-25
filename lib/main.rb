# frozen_string_literal: true

require_relative 'chess_board.rb'
require_relative 'pieces/piece.rb'
require_relative 'pieces/king.rb'
require_relative 'pieces/queen.rb'
require_relative 'pieces/rook.rb'
require_relative 'pieces/bishop.rb'
require_relative 'pieces/knight.rb'
require_relative 'pieces/pawn.rb'

board = ChessBoard.new
board.initial_placement
# white_pawn = Pawn.new(:white)
# black_pawn = Pawn.new(:black)
# board.update_value(1, 0, black_pawn)
# board.update_value(6, 0, white_pawn)
board.to_s
# mover = board.select_piece(1, 0)
# puts "mover is #{mover}"
# board.update_value(2, 0, mover)
# board.update_value(1, 0, nil)
# board.to_s

# king => " \u265A "
# queen => " \u265B "
# rook => " \u265C "
# bishop => " \u265D "
# knight => " \u265E "
# pawn => " \u265F "
