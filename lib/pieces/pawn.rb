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
  def update_moves
    # Should only work if there is not a piece in the spot
    @moves = []
    movement = color == :white ? -1 : 1
    @moves << [@location[0] + movement, @location[1]]
    additional_new_move unless @moved
  end

  # Can this be split up into 2 methods
  # Should black & white pawns be in two different classes?
  # Tested
  def update_captures
    # Should captures only work if there is a piece in the spot?
    @captures = []
    row = @location[0]
    column = @location[1]
    movement = color == :white ? -1 : 1
    @captures << [row + movement, column - 1] if column >= 1
    @captures << [row + movement, column + 1] if column <= 6
  end

  # Need to Test
  def valid_moves?(board)
    update_moves
    update_captures
    valid_empty_moves?(board) || valid_capture_moves?(board)
  end

  def valid_empty_moves?(board)
    moves.any? { |moves| !board[moves[0]][moves[1]] }
  end

  def valid_capture_moves?(board)
    captures.any? { |moves| board[moves[0]][moves[1]] }
  end

  private

  def additional_new_move
    movement = color == :white ? -2 : 2
    @moves << [@location[0] + movement, @location[1]]
  end
end
