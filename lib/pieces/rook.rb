# frozen_string_literal: true

require_relative 'piece'

# logic for each chess piece
class Rook < Piece
  attr_reader :color, :symbol

  def initialize(args)
    super(args)
    @symbol = " \u265C "
  end

  def current_moves(board)
    # moves = []
    rank = @location[0]
    # file = @location[1]
    # file_moves(board[file])
    # moves
    rank_moves(board[rank])
  end

  def current_captures(_board)
    captures = []
    # rank = @location[0]
    # file = @location[1]
    captures
  end

  private

  # [LOCATION, nil, nil, nil, nil, PIECE, nil, nil]
  def rank_moves(rank)
    index = @location[1]
    empty_squares = []
    empty_squares << rank_increase(index, rank)
    empty_squares << rank_decrease(index, rank)
    empty_squares.flatten(1)
  end

  def rank_increase(index, rank)
    empty_increase = []
    num = 1
    until rank[index + num] || index + num > 7
      empty_increase << [@location[0], index + num]
      num += 1
    end
    empty_increase
  end

  def rank_decrease(index, rank)
    empty_decrease = []
    num = 1
    until rank[index - num] || (index - num).negative?
      empty_decrease << [@location[0], index - num]
      num += 1
    end
    empty_decrease
  end
end
