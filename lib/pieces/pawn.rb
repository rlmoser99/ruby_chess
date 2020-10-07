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
  # Can refactor!
  def current_moves(board)
    moves = []
    rank = @location[0] + rank_direction
    file = @location[1]
    moves << [rank, file] unless board[rank][file]
    bonus = first_move_bonus
    moves << bonus unless @moved || board[bonus[0]][bonus[1]]
    @moves = moves
  end

  # Tested
  # Can refactor!
  def current_captures(board, previous_piece)
    captures = []
    rank = @location[0] + rank_direction
    file = @location[1]
    lower_file = file - 1
    higher_file = file + 1
    captures << [rank, lower_file] if opposing_piece?(rank, lower_file, board)
    captures << [rank, higher_file] if opposing_piece?(rank, higher_file, board)
    captures << previous_piece.location if valid_en_passant?(previous_piece)
    @captures = captures
  end

  # White can only move up and Black can only move down
  def rank_direction
    color == :white ? -1 : 1
  end

  private

  # Tested in update_location
  # Changes en_passant value depending on if last move was two spaces (true) or not.
  def update_en_passant(row)
    @en_passant = (row - location[0]).abs == 2
  end

  def first_move_bonus
    double_rank = @location[0] + (rank_direction * 2)
    file = @location[1]
    [double_rank, file]
  end

  # Tested in current_captures
  # Checks that a piece is a pawn & that en_passant rank is valid
  def valid_en_passant?(piece)
    en_passant_rank? && symbol == piece.symbol && piece.en_passant
  end

  # Tested in current_captures
  # Checks if black pawn is in 4th row or white pawn is in 3rd row
  def en_passant_rank?
    (location[0] == 4 && color == :black) || (location[0] == 3 && color == :white)
  end
end
