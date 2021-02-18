# frozen_string_literal: true

require_relative 'piece'

# logic for pawn chess piece
class Pawn < Piece
  attr_reader :en_passant

  def initialize(board, args)
    super(board, args)
    @symbol = " \u265F "
    @moved = false
    @en_passant = false
  end

  def update_location(row, column)
    update_en_passant(row)
    @location = [row, column]
    @moved = true
  end

  def find_possible_moves(board)
    [single_move(board), double_bonus_move(board)].compact
  end

  def find_possible_captures(board)
    file = @location[1]
    [
      basic_capture(board, file - 1),
      basic_capture(board, file + 1),
      en_passant_capture(board)
    ].compact
  end

  # determines the mathematical direction - white moves up & black moves down
  def rank_direction
    color == :white ? -1 : 1
  end

  def en_passant_rank?
    rank = location[0]
    (rank == 4 && color == :black) || (rank == 3 && color == :white)
  end

  private

  def single_move(board)
    move = [@location[0] + rank_direction, @location[1]]
    return move unless board.data[move[0]][move[1]]
  end

  def double_bonus_move(board)
    double_rank = @location[0] + (rank_direction * 2)
    bonus = [double_rank, @location[1]]
    return bonus unless invalid_bonus_move?(board, bonus)
  end

  def invalid_bonus_move?(board, bonus)
    first_move = single_move(board)
    return true unless first_move

    @moved || board.data[bonus[0]][bonus[1]]
  end

  def basic_capture(board, file)
    rank = @location[0] + rank_direction
    return [rank, file] if opposing_piece?(rank, file, board.data)
  end

  def en_passant_capture(board)
    capture = board.previous_piece&.location
    return unless capture

    column_difference = (@location[1] - capture[1]).abs
    return unless column_difference == 1

    return capture if valid_en_passant?(board)
  end

  def update_en_passant(row)
    @en_passant = (row - location[0]).abs == 2
  end

  def valid_en_passant?(board)
    en_passant_rank? &&
      symbol == board.previous_piece.symbol &&
      board.previous_piece.en_passant &&
      legal_en_passant_move?(board)
  end

  # checks if the en passant move & capture will not leave the King in check
  def legal_en_passant_move?(board)
    pawn_location = board.previous_piece.location
    en_passant_move = [pawn_location[0], pawn_location[1] + rank_direction]
    temp_board = remove_captured_en_passant_pawn(board, pawn_location)
    legal_capture = remove_illegal_moves(temp_board, en_passant_move)
    legal_capture.size.positive?
  end

  def remove_captured_en_passant_pawn(board, pawn_location)
    temp_board = Marshal.load(Marshal.dump(board))
    temp_board.data[pawn_location[0]][pawn_location[1]] = nil
    temp_board
  end

  def move_set; end
end
