# frozen_string_literal: true

require_relative 'piece'

# logic for each chess piece
class Knight < Piece
  attr_reader :color, :symbol

  def initialize(args)
    super(args)
    @location = args[:location]
    @symbol = " \u265E "
  end

  def current_moves(board)
    moves = move_possibilities
    result = []
    moves.each do |move|
      rank = @location[0] + move[0]
      file = @location[1] + move[1]
      next unless rank.between?(0, 7) && file.between?(0, 7)

      result << [rank, file] unless board[rank][file]
    end
    result
  end

  def current_captures(board, _previous_piece)
    moves = move_possibilities
    result = []
    moves.each do |move|
      rank = @location[0] + move[0]
      file = @location[1] + move[1]
      next unless rank.between?(0, 7) && file.between?(0, 7)

      result << [rank, file] if opposing_piece?(rank, file, board)
    end
    result
  end

  private

  def move_possibilities
    [
      [-1, -2], [1, 2], [-1, 2], [1, -2], [-2, -1], [2, 1], [-2, 1], [2, -1]
    ]
  end

  def opposing_piece?(rank, file, board)
    piece = board[rank][file]
    piece && piece.color != color
  end
end
