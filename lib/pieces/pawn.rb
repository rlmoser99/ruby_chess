# frozen_string_literal: true

require_relative 'piece'

# logic for each chess piece
class Pawn < Piece
  attr_reader :color, :symbol, :location, :en_passant, :moves, :captures

  def initialize(board, args)
    board.add_observer(self)
    @color = args[:color]
    @location = args[:location]
    @symbol = " \u265F "
    @moved = false
    @en_passant = false
    @moves = []
    @captures = []
  end

  def update_location(row, column)
    update_en_passant(row)
    @location = [row, column]
    @moved = true
  end

  # Tested
  def find_possible_moves(board)
    [single_move(board), double_bonus_move(board)].compact
  end

  # Tested
  def find_possible_captures(board)
    file = @location[1]
    [
      basic_capture(board, file - 1),
      basic_capture(board, file + 1),
      en_passant_capture(board.previous_piece)
    ].compact
  end

  # White can only move up and Black can only move down
  def rank_direction
    color == :white ? -1 : 1
  end

  # Tested
  # Checks if black pawn is in 4th row or white pawn is in 3rd row
  def en_passant_rank?
    (location[0] == 4 && color == :black) || (location[0] == 3 && color == :white)
  end

  private

  def single_move(board)
    move = [@location[0] + rank_direction, @location[1]]
    return move unless board.data[move[0]][move[1]]
  end

  def double_bonus_move(board)
    double_rank = @location[0] + (rank_direction * 2)
    bonus = [double_rank, @location[1]]
    return bonus unless @moved || board.data[bonus[0]][bonus[1]]
  end

  def basic_capture(board, file)
    rank = @location[0] + rank_direction
    return [rank, file] if opposing_piece?(rank, file, board.data)
  end

  def en_passant_capture(previous_piece)
    capture = previous_piece&.location
    return capture if valid_en_passant?(previous_piece)
  end

  # Will only be true if the last move was the double_bonus_move
  def update_en_passant(row)
    @en_passant = (row - location[0]).abs == 2
  end

  # Checks for valid rank and if piece is a pawn & valid en_passant
  def valid_en_passant?(piece)
    en_passant_rank? && symbol == piece.symbol && piece.en_passant
  end

  def move_set; end
end
