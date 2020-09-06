# frozen_string_literal: true

require_relative 'piece'

# logic for each chess piece
class Pawn < Piece
  attr_reader :color, :symbol, :moves, :location, :captures

  def initialize(args)
    super(args)
    @symbol = " \u265F "
    @location = args[:location]
    @moves = []
    @captures = []
    @moved = false
  end

  # Tested
  # add valid move for en passant
  def update_moves(movement)
    # Should only work if there is not a piece in the spot
    @moves = []
    @moves << [@location[0] + movement, @location[1]]
    additional_new_move(movement * 2) unless @moved
    # additional new move (movement x 2)
    # new_moves
  end

  # Can this be split up into 2 methods
  # Tested ???
  def update_captures(movement)
    @captures = []
    row = @location[0]
    column = @location[1]
    @captures << [row + movement, column - 1] if column >= 1
    @captures << [row + movement, column + 1] if column <= 6
  end

  # Need to Test
  def update_moves_captures
    update_moves(rank_direction)
    update_captures(rank_direction)
  end

  # Tested
  def current_moves(board)
    moves = []
    rank = @location[0] + rank_direction
    file = @location[1]
    moves << [rank, file] unless board[rank][file]
    bonus = first_move_bonus
    moves << bonus unless @moved || board[bonus[0]][bonus[1]]
    moves
  end

  # Tested
  def current_captures(board)
    captures = []
    rank = @location[0] + rank_direction
    lower_file = @location[1] - 1
    higher_file = @location[1] + 1
    captures << [rank, lower_file] if lower_capture?(rank, lower_file, board)
    captures << [rank, higher_file] if higher_capture?(rank, higher_file, board)
    captures
  end

  private

  def lower_capture?(rank, file, board)
    piece = board[rank][file]
    file >= 1 && piece && piece.color != color
  end

  def higher_capture?(rank, file, board)
    piece = board[rank][file]
    file <= 6 && piece && piece.color != color
  end

  def first_move_bonus
    double_rank = @location[0] + (rank_direction * 2)
    file = @location[1]
    [double_rank, file]
  end

  def rank_direction
    color == :white ? -1 : 1
  end
end
