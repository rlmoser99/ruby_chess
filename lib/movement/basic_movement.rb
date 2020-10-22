# frozen_string_literal: true

# contains logic for basic moves for all pieces
class BasicMovement
  attr_reader :row, :column, :board

  def initialize
    @board = nil
    @row = nil
    @column = nil
  end

  def update_pieces(board, coords)
    @board = board
    @row = coords[:row]
    @column = coords[:column]
    update_basic_moves
  end

  private

  def update_basic_moves
    remove_capture_piece_observer if @board.data[row][column]
    update_new_coordinates
    remove_original_piece
    update_active_piece_location
  end

  def remove_capture_piece_observer
    @board.delete_observer(@board.data[row][column])
  end

  def update_new_coordinates
    @board.data[row][column] = @board.active_piece
  end

  def remove_original_piece
    location = @board.active_piece.location
    @board.data[location[0]][location[1]] = nil
  end

  def update_active_piece_location
    @board.active_piece.update_location(row, column)
  end
end
