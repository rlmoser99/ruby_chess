# frozen_string_literal: true

require_relative 'piece'

# logic for each chess piece
class King < Piece
  attr_reader :color, :symbol

  def initialize(_board, args)
    @color = args[:color]
    @location = args[:location]
    @symbol = " \u265A "
  end

  def current_moves(board)
    possibilities = find_valid_moves(board.data).compact
    @moves = remove_king_check_moves(board, possibilities)
  end

  def current_captures(board, _previous_piece)
    @captures = find_valid_captures(board).compact
  end

  private

  def create_moves(board, rank_change, file_change)
    rank = @location[0] + rank_change
    file = @location[1] + file_change
    return unless valid_location?(rank, file)

    [rank, file] unless board[rank][file]
  end

  def create_captures(board, rank_change, file_change)
    rank = @location[0] + rank_change
    file = @location[1] + file_change
    return unless valid_location?(rank, file)

    [rank, file] if opposing_piece?(rank, file, board)
  end

  def move_set
    [[0, 1], [0, -1], [-1, 0], [1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1]]
  end
end
