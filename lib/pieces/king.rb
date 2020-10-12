# frozen_string_literal: true

require_relative 'piece'

# logic for each chess piece
class King < Piece
  attr_reader :color, :symbol, :moves, :captures

  def initialize(board, args)
    board.add_observer(self)
    @color = args[:color]
    @location = args[:location]
    @symbol = " \u265A "
    @moves = []
    @captures = []
  end

  def current_moves(board)
    possibilities = format_valid_moves(board)
    @moves = remove_king_check_moves(board, possibilities)
  end

  def current_captures(board)
    possibilities = format_valid_captures(board)
    @captures = remove_king_check_moves(board, possibilities)
  end

  def format_valid_moves(board)
    find_valid_moves(board.data).compact
  end

  def format_valid_captures(board)
    find_valid_captures(board.data).compact
  end

  private

  def create_moves(data, rank_change, file_change)
    rank = @location[0] + rank_change
    file = @location[1] + file_change
    return unless valid_location?(rank, file)

    [rank, file] unless data[rank][file]
  end

  def create_captures(data, rank_change, file_change)
    rank = @location[0] + rank_change
    file = @location[1] + file_change
    return unless valid_location?(rank, file)

    [rank, file] if opposing_piece?(rank, file, data)
  end

  def move_set
    [[0, 1], [0, -1], [-1, 0], [1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1]]
  end
end
