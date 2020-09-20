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
  def current_captures(board)
    # Need to check for a piece that can be captured en_passant
    # Black in 4th rank & White in 5th rank might be able to do en passant.
    captures = []
    rank = @location[0] + rank_direction
    file = @location[1]
    lower_file = file - 1
    higher_file = file + 1
    captures << [rank, lower_file] if opposing_piece?(rank, lower_file, board)
    captures << [rank, higher_file] if opposing_piece?(rank, higher_file, board)
    captures
  end

  private

  # Tested in update_location
  def update_en_passant(row)
    @en_passant = row - location[0] == 2
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

# Black in 4th rank & White in 5th rank can do en passant, to an opposing pawn.
# That opposing piece must have just done it's "double" move.
