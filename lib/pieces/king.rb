# frozen_string_literal: true

require_relative 'piece'

# logic for each chess piece
class King < Piece
  attr_reader :color, :symbol

  def initialize(args)
    super(args)
    @symbol = " \u265A "
  end

  def current_moves(board)
    find_valid_moves(board).compact
  end

  def current_captures(board, _previous_piece)
    find_valid_captures(board).compact
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

# Adding "check" to King.
# Check -> When opponent piece can attack King.
# Update legal moves -> Move can not put King in check.

# Visualizing valid moves & captures
# If a move would put King in check, it needs to be removed!!!

# Game ->
# Make a method inside #select_move_coordinates that has board check opponent pieces putting King into check.
