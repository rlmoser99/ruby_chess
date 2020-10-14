# frozen_string_literal: true

require_relative 'piece'

# logic for each chess piece
class Knight < Piece
  def initialize(board, args)
    board.add_observer(self)
    @color = args[:color]
    @location = args[:location]
    @symbol = " \u265E "
    @moves = []
    @captures = []
  end

  # Tested
  def find_possible_moves(board)
    possibilities = []
    move_set.each do |move|
      rank = @location[0] + move[0]
      file = @location[1] + move[1]
      next unless rank.between?(0, 7) && file.between?(0, 7)

      possibilities << [rank, file] unless board.data[rank][file]
    end
    possibilities
  end

  # Tested
  def find_possible_captures(board)
    result = []
    move_set.each do |move|
      rank = @location[0] + move[0]
      file = @location[1] + move[1]
      next unless rank.between?(0, 7) && file.between?(0, 7)

      result << [rank, file] if opposing_piece?(rank, file, board.data)
    end
    @captures = result
  end

  private

  def move_set
    [
      [-1, -2], [1, 2], [-1, 2], [1, -2], [-2, -1], [2, 1], [-2, 1], [2, -1]
    ]
  end
end
