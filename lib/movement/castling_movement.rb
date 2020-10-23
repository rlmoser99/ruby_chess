# frozen_string_literal: true

require_relative 'basic_movement'

# contains logic for castling moves
class CastlingMovement < BasicMovement
  def initialize
    @board = nil
    @row = nil
    @column = nil
  end

  def update_pieces(board, coords)
    @board = board
    @row = coords[:row]
    @column = coords[:column]
    update_castling_moves
  end

  private

  def update_castling_moves
    update_new_coordinates
    remove_original_piece
    update_active_piece_location
    castling_rook = find_castling_rook
    remove_original_rook_piece
    update_castling_coordinates(castling_rook)
    update_castling_piece_location(castling_rook)
  end

  def find_castling_rook
    @board.data[row][old_rook_column]
  end

  def remove_original_rook_piece
    @board.data[row][old_rook_column] = nil
  end

  def update_castling_coordinates(rook)
    @board.data[row][new_rook_column] = rook
  end

  def update_castling_piece_location(rook)
    rook.update_location(row, new_rook_column)
  end

  def old_rook_column
    king_side = 7
    queen_side = 0
    column == 6 ? king_side : queen_side
  end

  def new_rook_column
    king_side = 5
    queen_side = 3
    column == 6 ? king_side : queen_side
  end
end
