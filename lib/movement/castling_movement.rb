# frozen_string_literal: true

require_relative 'basic_movement'

# contains logic for castling moves
class CastlingMovement < BasicMovement
  def initialize(board = nil, row = nil, column = nil)
    @board = board
    @row = row
    @column = column
  end

  # updates instance variables and runs script to update castling moves
  def update_pieces(board, coords)
    @board = board
    @row = coords[:row]
    @column = coords[:column]
    update_castling_moves
  end

  private

  # script to update castling moves
  def update_castling_moves
    update_new_coordinates
    remove_original_piece
    update_active_piece_location
    castling_rook = find_castling_rook
    remove_original_rook_piece
    update_castling_coordinates(castling_rook)
    update_castling_piece_location(castling_rook)
  end

  # finds the king-side or queen-side rook for this castling move
  def find_castling_rook
    @board.data[row][old_rook_column]
  end

  # removes the original rook that was copied to a new location
  def remove_original_rook_piece
    @board.data[row][old_rook_column] = nil
  end

  # updates the board with new rook's piece in the new location
  def update_castling_coordinates(rook)
    @board.data[row][new_rook_column] = rook
  end

  # sends message to rook to updates its location
  def update_castling_piece_location(rook)
    rook.update_location(row, new_rook_column)
  end

  # determines rook's original location based on the column of the king's move
  def old_rook_column
    king_side = 7
    queen_side = 0
    column == 6 ? king_side : queen_side
  end

  # determines rook's new location based on the column of the king's move
  def new_rook_column
    king_side = 5
    queen_side = 3
    column == 6 ? king_side : queen_side
  end
end
