# frozen_string_literal: true

require_relative 'basic_movement'

# contains logic for en passant moves
class EnPassantMovement < BasicMovement
  def initialize
    @board = nil
    @row = nil
    @column = nil
  end
  
  def update_pieces(board, coords)
    @board = board
    @row = coords[:row]
    @column = coords[:column]
    update_en_passant_moves
  end

  private

  def update_en_passant_moves
    remove_capture_piece_observer
    update_new_coordinates
    remove_original_piece
    remove_en_passant_capture
    update_active_piece_location
  end

  def update_new_coordinates
    @board.data[new_rank][column] = @board.active_piece
  end

  def remove_en_passant_capture
    @board.data[row][column] = nil
  end

  def update_active_piece_location
    @board.active_piece.update_location(new_rank, column)
  end

  def new_rank
    row + @board.active_piece.rank_direction
  end
end
