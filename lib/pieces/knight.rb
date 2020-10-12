# frozen_string_literal: true

require_relative 'piece'

# logic for each chess piece
class Knight < Piece
  attr_reader :color, :symbol, :moves, :captures

  def initialize(board, args)
    board.add_observer(self)
    @color = args[:color]
    @location = args[:location]
    @symbol = " \u265E "
    @moves = []
    @captures = []
  end

  # refactor!!!
  def current_moves(board)
    possibilities = find_valid_moves(board)
    @moves = remove_king_check_moves(board, possibilities)
  end

  def find_valid_moves(board)
    moves = move_possibilities
    possibilities = []
    moves.each do |move|
      rank = @location[0] + move[0]
      file = @location[1] + move[1]
      next unless rank.between?(0, 7) && file.between?(0, 7)

      possibilities << [rank, file] unless board.data[rank][file]
    end
    possibilities
  end

  # refactor!!!
  def current_captures(board)
    possibilities = format_valid_captures(board)
    @captures = remove_king_check_moves(board, possibilities)
  end

  def format_valid_captures(board)
    moves = move_possibilities
    result = []
    moves.each do |move|
      rank = @location[0] + move[0]
      file = @location[1] + move[1]
      next unless rank.between?(0, 7) && file.between?(0, 7)

      result << [rank, file] if opposing_piece?(rank, file, board.data)
    end
    @captures = result
  end

  private

  def move_possibilities
    [
      [-1, -2], [1, 2], [-1, 2], [1, -2], [-2, -1], [2, 1], [-2, 1], [2, -1]
    ]
  end

  def opposing_piece?(rank, file, data)
    piece = data[rank][file]
    piece && piece.color != color
  end
end
