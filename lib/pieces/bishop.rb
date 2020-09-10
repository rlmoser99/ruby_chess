# frozen_string_literal: true

require_relative 'piece'

# logic for each chess piece
class Bishop < Piece
  attr_reader :color, :symbol

  def initialize(args)
    super(args)
    @location = args[:location]
    @symbol = " \u265D "
  end

  def current_moves(board)
    diagonal_moves(board, 1, -1) + diagonal_moves(board, 1, 1) + diagonal_moves(board, -1, 1) + diagonal_moves(board, -1, -1)
  end

  def current_captures(board)
    board
  end

  # def rank_up_file_down(board)
  #   rank = @location[0] + 1
  #   file = @location[1] - 1
  #   up_down = []
  #   until board[rank][file] || rank > 7 || file.negative?
  #     up_down << [rank, file]
  #     rank += 1
  #     file -= 1
  #   end
  #   up_down
  # end

  # def rank_up_file_up(board)
  #   rank = @location[0] + 1
  #   file = @location[1] + 1
  #   up_up = []
  #   until board[rank][file] || rank > 7 || file > 7
  #     up_up << [rank, file]
  #     rank += 1
  #     file += 1
  #   end
  #   up_up
  # end

  # def rank_down_file_up(board)
  #   rank = @location[0] - 1
  #   file = @location[1] + 1
  #   down_up = []
  #   until board[rank][file] || rank.negative? || file > 7
  #     down_up << [rank, file]
  #     rank -= 1
  #     file += 1
  #   end
  #   down_up
  # end

  # def rank_down_file_down(board)
  #   rank = @location[0] - 1
  #   file = @location[1] - 1
  #   down_down = []
  #   until board[rank][file] || rank.negative? || file.negative?
  #     down_down << [rank, file]
  #     rank -= 1
  #     file -= 1
  #   end
  #   down_down
  # end

  def diagonal_moves(board, rank_change, file_change)
    count = 1
    rank = @location[0] + rank_change
    file = @location[1] + file_change
    result = []
    until board[rank][file] || invalid_location?(rank, file)
      result << [rank, file]
      count += 1
      rank = @location[0] + (rank_change * count)
      file = @location[1] + (file_change * count)
    end
    result
  end

  def invalid_location?(rank, file)
    rank.negative? || file.negative? || rank > 7 || file > 7
  end
end
