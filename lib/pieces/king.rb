# frozen_string_literal: true

require_relative 'piece'

# logic for king chess piece
class King < Piece
  def initialize(board, args)
    board.add_observer(self)
    @color = args[:color]
    @location = args[:location]
    @symbol = " \u265A "
    @moved = false
    @moves = []
    @captures = []
  end

  # iterates through king's move_set and adds any castling moves
  def find_possible_moves(board)
    moves = move_set.inject([]) do |memo, move|
      memo << create_moves(board.data, move[0], move[1])
    end
    moves += castling_moves(board)
    moves.compact
  end

  private

  # creates moves based on move_set changing rank and file
  def create_moves(data, rank_change, file_change)
    rank = @location[0] + rank_change
    file = @location[1] + file_change
    return unless valid_location?(rank, file)

    [rank, file] unless data[rank][file]
  end

  # creates captures based on move_set changing rank and file
  def create_captures(data, rank_change, file_change)
    rank = @location[0] + rank_change
    file = @location[1] + file_change
    return unless valid_location?(rank, file)

    [rank, file] if opposing_piece?(rank, file, data)
  end

  # creates castling moves when specific conditions are met
  def castling_moves(board)
    castling_moves = []
    rank = location[0]
    castling_moves << [rank, 6] if king_side_castling?(board)
    castling_moves << [rank, 2] if queen_side_castling?(board)
    castling_moves
  end

  # defines the file numbers and checks conditions for king_side
  def king_side_castling?(board)
    king_side_pass = 5
    empty_files = [6]
    king_side_rook = 7
    unmoved_king_rook?(board, king_side_rook) &&
      empty_files?(board, empty_files) &&
      king_pass_through_safe?(board, king_side_pass)
  end

  # defines the file numbers and checks conditions for queen_side
  def queen_side_castling?(board)
    queen_side_rook = 0
    empty_files = [1, 2]
    queen_side_pass = 3
    unmoved_king_rook?(board, queen_side_rook) &&
      empty_files?(board, empty_files) &&
      king_pass_through_safe?(board, queen_side_pass)
  end

  # returns true if king and rook have not moved
  def unmoved_king_rook?(board, file)
    piece = board.data[location[0]][file]
    return false unless piece

    moved == false && piece.symbol == " \u265C " && piece.moved == false
  end

  # returns true if neighboring square is empty & king has safe passage
  def king_pass_through_safe?(board, file)
    rank = location[0]
    board.data[rank][file].nil? && safe_passage?(board, [rank, file])
  end

  # returns true if no pieces can move/capture in the neighboring square
  def safe_passage?(board, location)
    pieces = board.data.flatten(1).compact
    pieces.none? do |piece|
      next unless piece.color != color && piece.symbol != symbol

      moves = piece.find_possible_moves(board)
      moves.include?(location)
    end
  end

  # returns true if the specifed files are empty
  def empty_files?(board, files)
    files.none? { |file| board.data[location[0]][file] }
  end

  # list of possible directions that a king can move
  def move_set
    [[0, 1], [0, -1], [-1, 0], [1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1]]
  end
end
