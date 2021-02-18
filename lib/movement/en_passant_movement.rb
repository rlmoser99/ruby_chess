# frozen_string_literal: true

require_relative 'basic_movement'

# contains logic for en passant moves
class EnPassantMovement < BasicMovement
  def initialize(board = nil, row = nil, column = nil)
    super
  end

  def update_pieces(board, coords)
    @board = board
    @row = coords[:row]
    @column = coords[:column]
    update_en_passant_moves
  end

  def update_en_passant_moves
    remove_capture_piece_observer
    update_active_pawn_coordinates
    remove_original_piece
    remove_en_passant_capture
    update_active_piece_location
  end

  def update_active_pawn_coordinates
    @board.data[new_rank][column] = @board.active_piece
  end

  def remove_en_passant_capture
    @board.data[row][column] = nil
  end

  def update_active_piece_location
    @board.active_piece.update_location(new_rank, column)
  end

  private

  # determines the new rank of the pawn based on its rank direction
  def new_rank
    row + @board.active_piece.rank_direction
  end
end
