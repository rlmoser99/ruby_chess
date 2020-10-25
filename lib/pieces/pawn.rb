# frozen_string_literal: true

require_relative 'piece'

# logic for pawn chess piece
class Pawn < Piece
  attr_reader :en_passant

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

  # updates the values of @location, @moved and @en_passant
  def update_location(row, column)
    update_en_passant(row)
    @location = [row, column]
    @moved = true
  end

  # combines possible moves for single and double moves
  def find_possible_moves(board)
    [single_move(board), double_bonus_move(board)].compact
  end

  # combines possible captures for basic and en passant
  def find_possible_captures(board)
    file = @location[1]
    [
      basic_capture(board, file - 1),
      basic_capture(board, file + 1),
      en_passant_capture(board.previous_piece)
    ].compact
  end

  # determines the mathematical direction - white moves up & black moves down
  def rank_direction
    color == :white ? -1 : 1
  end

  # returns true if a black pawn is in 4th row or white pawn is in 3rd row
  def en_passant_rank?
    rank = location[0]
    (rank == 4 && color == :black) || (rank == 3 && color == :white)
  end

  private

  # creates a move if the square is unoccupied
  def single_move(board)
    move = [@location[0] + rank_direction, @location[1]]
    return move unless board.data[move[0]][move[1]]
  end

  # creates the bonus move if unmoved and both squares are unoccupied
  def double_bonus_move(board)
    double_rank = @location[0] + (rank_direction * 2)
    bonus = [double_rank, @location[1]]
    return bonus unless invalid_bonus_move?(board, bonus)
  end

  # returns false when unmoved and both squares are unoccupied
  def invalid_bonus_move?(board, bonus)
    first_move = single_move(board)
    return true unless first_move

    @moved || board.data[bonus[0]][bonus[1]]
  end

  # creates diagonal capture if piece is opposing
  def basic_capture(board, file)
    rank = @location[0] + rank_direction
    return [rank, file] if opposing_piece?(rank, file, board.data)
  end

  # creates a capture if there are valid en passant conditions
  def en_passant_capture(previous_piece)
    capture = previous_piece&.location
    return unless capture

    column_difference = (@location[1] - capture[1]).abs
    return unless column_difference == 1

    return capture if valid_en_passant?(previous_piece)
  end

  # returns true if the last move was the double_bonus_move
  def update_en_passant(row)
    @en_passant = (row - location[0]).abs == 2
  end

  # returns true if rank is valid & piece is a pawn with en_passant
  def valid_en_passant?(piece)
    en_passant_rank? && symbol == piece.symbol && piece.en_passant
  end

  def move_set; end
end
