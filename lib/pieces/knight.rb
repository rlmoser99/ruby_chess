# frozen_string_literal: true

require_relative 'piece'

# logic for knight chess piece
class Knight < Piece
  def initialize(board, args)
    super(board, args)
    @symbol = " \u265E "
    @captures = []
  end

  # iterates over move_set and adds the location as a move when valid
  def find_possible_moves(board)
    possibilities = []
    move_set.each do |move|
      rank = @location[0] + move[0]
      file = @location[1] + move[1]
      next unless valid_location?(rank, file)

      possibilities << [rank, file] unless board.data[rank][file]
    end
    possibilities
  end

  # iterates over move_set and adds the location as a capture when valid
  def find_possible_captures(board)
    result = []
    move_set.each do |move|
      rank = @location[0] + move[0]
      file = @location[1] + move[1]
      next unless valid_location?(rank, file)

      result << [rank, file] if opposing_piece?(rank, file, board.data)
    end
    @captures = result
  end

  private

  def move_set
    [[-1, -2], [1, 2], [-1, 2], [1, -2], [-2, -1], [2, 1], [-2, 1], [2, -1]]
  end
end
