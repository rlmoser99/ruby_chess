# frozen_string_literal: true

require_relative 'piece'

# logic for each chess piece
class Rook < Piece
  attr_reader :color, :symbol

  def initialize(args)
    super(args)
    @location = args[:location]
    @symbol = " \u265C "
  end

  def current_moves(board)
    moves = []
    rank = @location[0]
    moves << rank_moves(board[rank])
    moves << file_moves(board)
    moves.flatten(1)
  end

  def current_captures(_board)
    captures = []
    # rank = @location[0]
    # file = @location[1]
    captures
  end

  private

  def rank_moves(rank)
    index = @location[1]
    empty_squares = []
    empty_squares << rank_increase(index + 1, rank)
    empty_squares << rank_decrease(index - 1, rank)
    empty_squares.flatten(1)
  end

  def file_moves(board)
    file = board.transpose[@location[1]]
    index = @location[0]
    empty_squares = []
    empty_squares << file_increase(index + 1, file)
    empty_squares << file_decrease(index - 1, file)
    empty_squares.flatten(1)
  end

  def rank_increase(index, row)
    empty_increase = []
    until row[index] || index > 7
      empty_increase << [@location[0], index]
      index += 1
    end
    empty_increase
  end

  def rank_decrease(index, row)
    empty_decrease = []
    until row[index] || index.negative?
      empty_decrease << [@location[0], index]
      index -= 1
    end
    empty_decrease
  end

  def file_increase(index, row)
    empty_increase = []
    until row[index] || index > 7
      empty_increase << [index, @location[1]]
      index += 1
    end
    empty_increase
  end

  def file_decrease(index, row)
    empty_decrease = []
    until row[index] || index.negative?
      empty_decrease << [index, @location[1]]
      index -= 1
    end
    empty_decrease
  end
end
