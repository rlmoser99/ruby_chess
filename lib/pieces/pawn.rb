# frozen_string_literal: true

require_relative 'piece'

# logic for each chess piece
class Pawn < Piece
  attr_reader :color, :symbol, :location

  def initialize(args)
    super(args)
    @symbol = " \u265F "
    @location = args[:location]
    @moved = false
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
    file = @location[1]
    lower_file = file - 1
    higher_file = file + 1
    captures << [rank, lower_file] if lower_capture?(rank, lower_file, board)
    captures << [rank, higher_file] if higher_capture?(rank, higher_file, board)
    captures
  end

  private

  def lower_capture?(rank, file, board)
    piece = board[rank][file]
    file >= 0 && piece && piece.color != color
  end

  def higher_capture?(rank, file, board)
    piece = board[rank][file]
    file <= 7 && piece && piece.color != color
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
