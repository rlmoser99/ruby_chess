# frozen_string_literal: true

require_relative 'piece'

# logic for each chess piece
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

  # Tested
  def find_possible_moves(board)
    moves = move_set.inject([]) do |memo, move|
      memo << create_moves(board.data, move[0], move[1])
    end
    moves += add_castling_moves(board)
    moves.compact
  end

  private

  def create_moves(data, rank_change, file_change)
    rank = @location[0] + rank_change
    file = @location[1] + file_change
    return unless valid_location?(rank, file)

    [rank, file] unless data[rank][file]
  end

  def create_captures(data, rank_change, file_change)
    rank = @location[0] + rank_change
    file = @location[1] + file_change
    return unless valid_location?(rank, file)

    [rank, file] if opposing_piece?(rank, file, data)
  end

  def add_castling_moves(board)
    castling_moves = []
    castling_moves << [location[0], 6] if king_side_castling?(board)
    castling_moves << [location[0], 2] if queen_side_castling?(board)
    castling_moves
  end

  # Tested
  def king_side_castling?(board)
    king_side_pass = 5
    empty_files = [6]
    king_side_rook = 7
    king_rook_unmoved?(board, king_side_rook) &&
      empty_board_files(board, empty_files) &&
      king_pass_through_safe?(board, king_side_pass)
  end

  # Tested
  def queen_side_castling?(board)
    queen_side_rook = 0
    empty_files = [1, 2]
    queen_side_pass = 3
    king_rook_unmoved?(board, queen_side_rook) &&
      empty_board_files(board, empty_files) &&
      king_pass_through_safe?(board, queen_side_pass)
  end

  def king_rook_unmoved?(board, file)
    piece = board.data[location[0]][file]
    return false unless piece

    moved == false && piece.symbol == " \u265C " && piece.moved == false
  end

  def king_pass_through_safe?(board, file)
    rank = location[0]
    board.data[rank][file].nil? && safe_passage?(board, [rank, file])
  end

  def safe_passage?(board, location)
    pieces = board.data.flatten(1).compact
    pieces.none? do |piece|
      next unless piece.color != color && piece.symbol != symbol

      moves = piece.find_possible_moves(board)
      moves.include?(location)
    end
  end

  def empty_board_files(board, files)
    files.all? { |file| board.data[location[0]][file].nil? }
  end

  def move_set
    [[0, 1], [0, -1], [-1, 0], [1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1]]
  end
end
