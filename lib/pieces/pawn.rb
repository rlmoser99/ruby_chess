# frozen_string_literal: true

require_relative 'piece'

# logic for each chess piece
class Pawn < Piece
  attr_reader :color, :symbol, :location, :en_passant

  def initialize(args)
    super(args)
    @symbol = " \u265F "
    @location = args[:location]
    @moved = false
    @en_passant = false
  end

  def update_location(row, column)
    update_en_passant(row)
    # check to see if en_passant capture is happening?
    @location = [row, column]
    @moved = true
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
  def current_captures(board, previous_piece)
    # Need to check for a piece that can be captured en_passant
    captures = []
    rank = @location[0] + rank_direction
    file = @location[1]
    lower_file = file - 1
    higher_file = file + 1
    captures << [rank, lower_file] if opposing_piece?(rank, lower_file, board)
    captures << [rank, higher_file] if opposing_piece?(rank, higher_file, board)
    captures << previous_piece.location if valid_en_passant?(previous_piece)
    captures
  end

  # White can only move up and Black can only move down
  def rank_direction
    color == :white ? -1 : 1
  end

  private

  # Tested in update_location
  # Determines whether a move was two spaces (true) or not.
  def update_en_passant(row)
    @en_passant = (row - location[0]).abs == 2
  end

  def first_move_bonus
    double_rank = @location[0] + (rank_direction * 2)
    file = @location[1]
    [double_rank, file]
  end

  # Tested in current_captures
  # Checks that a piece is a pawn & that is en_passant is true
  def valid_en_passant?(piece)
    en_passant_rank? && symbol == piece.symbol && piece.en_passant
  end

  # White Pawn must be in 3rd row or Black Pawn must be in 4th row
  def en_passant_rank?
    (location[0] == 4 && color == :black) || (location[0] == 3 && color == :white)
  end
end

# Removes the captures piece & places piece on square in front
# (as if captured piece moved one square)

# Add warning in game when en_passant is a possibility to know that piece will be in different square!
